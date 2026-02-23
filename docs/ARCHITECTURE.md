# Shooter Carnival — Architecture Document
Last updated: 2026-02-20

## 1. Purpose

This document explains the technical architecture for Shooter Carnival:

- A **data-driven content pipeline** (waves/patterns/timelines) that enables many “good first issues.”
- A **message bus (event bus)** for decoupled gameplay systems.
- A clean separation between **runtime systems** (stable code) and **content** (additive assets).
- A consistent way to support **Campaign** and **Training** using the **same code paths**.

This is intended to guide contributors and maintainers on where code belongs and how systems integrate.

---

## 2. Repo Structure (as-is + planned subfolders)

The repository already uses:

- `src/assets/`
- `src/components/`
- `src/entities/`
- `src/resources/`
- `src/scenes/`
- `src/scripts/`

The architecture aligns to this and adds only subfolders.

### 2.1 Proposed pipeline-aligned layout

```text
src/
  entities/
    enemies/            # Enemy prefabs (scenes + scripts)
    pickups/            # Capsules, bells, medals
    projectiles/        # Bullets, bombs
    ships/              # Player ships

  resources/
    stages/
      stage_01/
        waves/
        drop_tables/
        timelines/
      stage_02/
        ...
    patterns/
      movement/
      firing/
    run_configs/        # Campaign vs Training

  scenes/
    stages/
    ui/

  scripts/
    runtime/            # StageRunner, WaveRunner, SpawnSystem
    systems/            # RunState, GameStats, ScoreSystem (when added)
```

**Rule of Thumb:** contributors should mostly touch `src/resources/**` and `src/entities/**`.
Maintainer-owned runtime systems live in `src/scripts/**`.

---

## 3. Architectural Pillars

1. **Data-driven stages**: stage flow is described in Resources (timelines/waves), executed by generic runtime code.
2. **Decoupled systems**: gameplay systems communicate via the message bus using small data payloads.
3. **Data-driven messages**: message payloads contain primitives/IDs and lightweight structs only (avoiding tight coupling & lifecycle bugs).
4. **Mode configuration**: Campaign vs Training differences are controlled by a single `RunConfig` module (no scattered `if training_mode` checks).
5. **Stable runtime, additive content**: adding content should rarely require editing runtime code.

---

## 4. Event Bus (MessageBus) — Current + Intended Use

### 4.1 What exists today

- A message bus exists under `src/components/messages/`:
  - `message_bus.gd` defines a `MessageType` enum and subscription/publish mechanism.
  - `message_payload.gd` defines payload classes such as:
    - `EnemyDeath`
    - `EnemyDamage`
    - `PlayerDamage`
    - `PlayerDeath`

The bus is used as a global singleton via something like:
- `GlobalUtils.CombatBus.publish(type, payload)`
- `GlobalUtils.CombatBus.subscribe(type).connect(handler)`

### 4.2 Why we use a bus
- Avoid direct references between systems (stage, UI, enemies, scoring).
- Make it easier for contributors to add features without threading references through scenes.

### 4.3 Hard rules for message payloads
**DO:**
- Use primitive values and small data objects:
  - `entity_id: int`
  - `position: Vector2`
  - `reward: int`
  - `damage: int`
  - `stage_id: String`
  - `weapon_id: String`

**DO NOT:**
- Pass `Node` references inside payloads.
  - Reason: tight coupling, lifecycle hazards, memory leaks, invalid references after `queue_free()`.

### 4.4 Recommended event taxonomy

Keep message types aligned to gameplay needs and scalable:

- CombatBus:
  - `ENEMY_SPAWNED`
  - `ENEMY_DAMAGED`
  - `ENEMY_DIED`
  - `PLAYER_DAMAGED`
  - `PLAYER_DIED`
  - `BOMB_USED`
  - `BULLET_CANCELED`
  - and so on

- EconomyBus (resource to be created):
  - `PICKUP_COLLECTED` (capsule, bell, medal)
  - `UPGRADE_APPLIED`

- StageBus (resource to be created):
  - `WAVE_STARTED`
  - `WAVE_COMPLETED`
  - `BOSS_STARTED`
  - `BOSS_DEFEATED`
  - `STAGE_COMPLETED`

Not all exist today; this is the target direction.

---

## 5. Content Pipeline — Architecture

### 5.1 Core rule

Resources must be configuration, not per-enemy state

**Problem to avoid*: If a single `.tres` pattern Resource is shared by many enemies and it stores mutable runtime state (timers, phase, random seed), enemies will interfere with each other.

Rule:

- A Pattern Resource contains only exported configuration (numbers, curves, enums).
- Runtime creates a per-enemy PatternInstance (stateful object) from the Resource.

This gives you the best of both worlds:
- easy tuning through `.tres`
- correct runtime behavior without shared-state bugs

### 5.2) Recommended architecture (3-layer pattern model)

#### Layer A - Pattern Resource (config asset)
- Stored as `.tres` under `src/resources/patterns/**`
- Contains exported params: amplitude, frequency, speed, burst count, etc.
- No `_process`, no timers, no state.

#### Layer B — PatternInstance (per-enemy runtime state)
- A lightweight object created per spawned enemy
- Holds mutable state: elapsed time, phase, cooldown, RNG

#### Layer C — Driver (enemy side)
- Enemy has:
  - `movement_instance`
  - `firing_instance`
- Enemy calls movement_instance.tick(delta) and firing_instance.tick(delta)
This keeps StageRunner/WaveRunner generic and prevents patterns from tightly coupling to the stage.

### 5.3 Where files go
- Pattern resources: `src/resources/patterns/movement/*.tres`, `src/resources/patterns/firing/*.tres`
- Pattern scripts (classes): `src/scripts/patterns/movement/*.gd`, `src/scripts/patterns/firing/*.gd`
- Wave resources reference the `.tres` pattern assets.
This keeps logic in `scripts/` and tuning in `resources/`.

### 5.4 Example API - what each piece should look like

#### 5.4.1 Movement pattern resource contract
Key responsibilities:
- Define exported config
- Provide a factory method to create the per-enemy instance

Conceptual interface:

`func create_instance(enemy: Node2D) -> MovementPatternInstance`

#### 5.4.2 Movement pattern instance contract
`func tick(delta: float) -> void`
optionally:
- `func on_spawn()`
- `func on_hit()`
- `func on_death()`

#### 5.4.3 Enemy contract
Enemy base script must provide a minimal interface that patterns can use:

- `global_position` / `position`
- `velocity` or a `move(delta, velocity)` hook
- `get_player_position()` optional, but better to route through a service
- `fire(projectile_id, direction, speed)` for firing patterns

**Important:** Patterns should not be poking around the scene tree for random nodes. That becomes fragile fast.

### 5.5) How waves reference patterns (data-driven)
WaveDef Resource fields should directly reference:
- `movement_pattern: MovementPatternResource`
- `firing_pattern: FiringPatternResource`

When WaveRunner spawns an enemy:
1. instantiate enemy scene
1. `enemy.set_movement_pattern(wave.movement_pattern)`
1. `enemy.set_firing_pattern(wave.firing_pattern)`

Enemy then internally:
- `movement_instance = movement_pattern.create_instance(self)`
- `firing_instance = firing_pattern.create_instance(self)`

This makes waves _pure_ content.

---

## 6 Pipeline Archicture Benefits

### 6.1 friendliness

With this structure, “good first issues” become:

#### Add a new tuned pattern variant (no code)
- Duplicate `sine_easy.tres` → `sine_medium.tres`
- Adjust amplitude/speed in inspector
- Use it in 1 wave `.tres`

#### Add a new pattern type (small code + example resource)
- Add one script under src/scripts/patterns/movement/
- Create one `.tres` instance under `src/resources/patterns/movement/`
- Add one wave using it

This is clean, reviewable, and low conflict.

### 6.2) Drawbacks (and how to mitigate them)

#### **Drawback:** more files (`.tres` instances)
You’ll have many small assets.

**Mitigation**: strict naming and folder conventions:
- `move_sine_easy.tres`
- `move_sine_fast.tres`
- `fire_aimed_burst_easy.tres`


#### **Drawback:** runtime instance code adds a bit of complexity

Yes, it’s more structure than “just a script,” but it prevents the shared-state bug class.

**Mitigation**: provide one template pattern and document “copy this.”

#### **Drawback:** resource diffs can be annoying

**Mitigation**: keep each `.tres` small and focused; don’t embed huge arrays in a single resource if you can avoid it.

---

## 7. Game Mode Configuration (Campaign vs Training)

### 7.1 RunConfig / GameModeConfig
A single object controls runtime behavior:

Core flags:
- `leaderboard_enabled: bool`
- `progression_enabled: bool`
- `show_training_watermark: bool`

Optional fields later:
- `difficulty_override`
- `starting_loadout` (for boss practice presets)

### 7.2 Training mode compliance
Training must:
- compute and display score/stats
- never persist:
  - leaderboard updates
  - campaign unlocks
  - high scores

---

## 8. System Responsibilities

### 8.1 Stage / content authors
- Create WaveDefs, patterns, and enemy scenes.
- Ensure assets validate and run in Stage Practice.

### 8.2 Runtime / code colaborators
- StageRunner, WaveRunner, SpawnSystem
- Event payload definitions
- RunConfig and persistence boundaries
- Refactors and stabilization sprints

---
