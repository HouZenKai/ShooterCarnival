# Shooter Carnival — Game Design Document (GDD)
Last updated: 2026-02-20

## 1. Purpose / Vision

**Shooter Carnival** is a community-driven, open-source 2D shoot-’em-up built in Godot (GDScript) as a playable homage to the golden age of arcade shooters.

**Primary goals**
1. **Fun and replayability first**: arcade “one more run” energy.
2. **Shmup best practices**: hard-but-fair challenge, readable patterns, strong feedback.
3. **Clean coding and maintainability** to support a community project.
4. **Contributor friendliness**: many small good first-issues,” data-driven content, small sprints.

**Non-goals (for early development)**
- Not building a giant “everything shmup” immediately.
- Not shipping competitive online features early.
- Not front-loading complex mechanics (bullet hell scoring, polarity) before the base game is fun.

---

## 2. Target Audience

- **Newcomers**: players who enjoy retro games or want to learn shmups.
- **Shmup fans**: players who want mastery, scoring depth, practice tools.
- **Contributors**: beginners to experienced developers/artists who want tangible, mergeable tasks.

---

## 3. Design Principles

### 3.1 Hard but fair
- No “cheap deaths” like off-screen snipes, untelegraphed point-blank spawns.
- New threats are introduced with **telegraphs**, visual and, or, sound cues.
- Difficulty ramps via density and timing, not by surprises.

### 3.2 One mechanic at a time
- Introduce systems gradually across stages.
- Each new mechanic gets a safe practice segment before being tested under pressure.

### 3.3 One spine, many plug-ins
A unified progression system prevents the game from feeling like disconnected homages.

**Spine system:** a **Gradius-style Upgrade Bar** (the “Loadout Builder”) that other mechanics plug into.

### 3.4 Data-driven content to maximize contributions
- Enemy patterns, waves, drop tables, and stage graphs should be editable without deep engine knowledge.
- Adding content should rarely require touching core systems., only data files.

---

## 4. Core Gameplay Loop

**Moment-to-moment**
1. Dodge bullets and hazards.
2. Shoot enemies.
3. Collect drops (capsules, bells, medals, etc.).
4. Spend/activate upgrades via the Upgrade Bar.
5. Survive waves → defeat boss → progress route/stage.

**Run-to-run**
- Replay stages/routes to improve performance, learn patterns, and try different builds.

---

## 5. Game Modes

### 5.1 Campaign Mode
- Primary progression: stages in sequence, with eventual branching routes.
- **Leaderboard/high score persists**.
- Progression unlocks:
  - New stages
  - Training availability for stages (see Training Mode)

### 5.2 Training Mode - Sandbox Practice
**Intent:** Practice content without progression pressure.

Rules:
- Scores and bonuses are still calculated and displayed like in campaing, feedback matters.
- **Training does not update campaign leaderboards, high scores, or progression.**
- Training must **reuse campaign code paths**, controlled by a configuration object (flags), DO NOT duplicate scenes.

Unlock rules:
- **Stage 1 Training is always available.**
- Unlock training for Stage N when the player **reaches** Stage N, not when they beat it.
- Unlock **Boss Practice** after the player loses to a boss once, keep the mystery 

Training variants (v1 → later):
- Stage Practice (full stage)
- Boss Practice (boss-only, with preset loadout)

---

## 6. Progression, Economy, and Systems Integration

### 6.1 Separation of concerns: Stats vs Run State
To keep architecture clean and contributor-friendly:

- **GameStats**: Answers “What happened?”, could show score, enemies defeated, time alive, chain, damage taken, etc.
- **RunState / LoadoutState**: Answers “What do I have?”, current upgrades, bell counts, weapon mode, bombs, drone level.

### 6.2 Central progression mechanic: Upgrade Bar (Gradius-lite)
Upgrade Bar is the unified in-run progression spine:
- Capsules provide **Upgrade Energy**.
- Player spends energy to activate/select an upgrade option.
- Upgrades start small and expand over time.

Early implementation (v1):
- Options: `Speed`, `Shot` (limited levels).

### 6.3 TwinBee Bells integrated with Upgrade Bar
Bells are **typed currency** that unlocks and improves upgrade options.

Design requirements:
- Bells do not directly modify player weapons; they modify RunState like unlocks and level caps.
- Bar UI must clearly show locked options and the required bell type to unlock it.

Recommended leveling model (v1-friendly):
- **Bells unlock + raise max level caps**
  - 1 bell unlocks the option (level 1)
  - more bells raise max level (e.g., to level 2/3 later)

Start with **2 bell colors** early to prevent overload.

### 6.4 Weapons and other features as “Upgrades”
As features grow (Raiden weapons, R-Type drone, bombs):
- Prefer implementing them as upgrade options or upgrade families for the Upgrade Bar.
- This keeps one mental model for players and one architecture model for developers.

### 6.5 Scoring systems will be introduced later
- Medals (Raiden flavor): simple value/streak or decay.
- Chain/Combo (DonPachi-lite): chain timer + multiplier.
- Bomb bullet cancel: bomb converts bullets to points (high feedback, optional depth).

**Rule:** scoring depth should never be required for basic survival.

### 6.6 Adaptive difficulty (Zanac-lite) — later or optional
If implemented:
- Use mild adjustments.
- Be transparent, show a difficulty tier, or players feel cheated.
- Never punish having upgrades aggressively.

### 6.7 Branching routes (Darius flavor)
- After certain bosses, offer A/B route choice.
- Routes bias content and drops (e.g., upgrades vs medals), while reusing assets.

---

## 7. Stage Progression - Player Learning Curve

### Core principle
Introduce 1 new concept every ~2 stages, then reinforce it.

High Level Example of staged progression:
- Stage 1–2: fundamentals + waves/formations
- Stage 3–4: upgrade bar (capsules)
- Stage 5–6: bells + bomb basics
- Stage 7–8: drone + weapon modes + medals
- Stage 9+: chain + bullet cancel + branching routes
- Optional mode: Adaptive difficulty (Zanac-inspired) as a separate ruleset
- Optional mode: polarity (Ikaruga-inspired) as a separate ruleset

---

## 8. Fairness and Readability Guidelines

### Hard Rules, Should Always be Followed
- Attacks must be telegraphed if they can kill quickly.
- Bullets must have readable contrast against backgrounds.
- Avoid off-screen spawns that immediately fire at the player.
- Avoid sudden bullet speed spikes without warning.
- Boss patterns should progress from “learnable” → “test” → “final.”

---

## 9. Technical Architecture Requirements

### 9.1 Event-driven messaging
- Use the message bus for decoupling systems.
- **Do not pass Nodes in message payloads.** Use IDs and data (player_id, position, reward, etc.).
- Payloads should be small, serializable data.

### 9.2 Run configuration instead of scattered `if training_mode`
Use a single config object (e.g., `RunConfig` / `GameModeConfig`) to control:
- leaderboard persistence
- progression enable/disable
- training watermarks
- optional difficulty overrides

### 9.3 Content pipeline first
Ensure contributors can add:
- movement patterns
- bullet patterns
- waves
- drop tables
- stage graphs/routes
mostly via data assets + small scripts.

---

## 10. Roadmap Structure Epics broken in Sprints

Each EPIC is broken into:
- **3 one-week development sprints (A/B/C)** shipping visible progress
- **1 one-week stabilization sprint (R)** for refactoring, cleanup, regression checks, documentation

Sprint naming convention:
- `Sprint <Epic number with two digits><A|B|C|R> - <epic summary>`

(See the roadmap discussion in planning docs / milestones.)

---

## 11. Risks / Drawbacks

- **Scope creep**: Too many mechanics too early will stall development and confuse players.
- **Balance debt**: typed currency (bells) + upgrade bar can snowball if not capped and tuned.
- **Flag sprawl**: training/campaign differences can rot code if not centralized in RunConfig.
- **Content scarcity**: systems without enough waves/enemies will feel pointless.
- **Community bottleneck**: if adding content requires touching core code, contributions slow down.

Mitigations:
- Keep early mechanics minimal (2 bell colors, 2 bar options).
- Prioritize content pipeline and stage fun before advanced scoring.
- Enforce payload and config rules to keep architecture clean.

---

## 12. Definition of Success (Early Versions)

**v0.1**
- One polished stage (Stage 1) that is replayable and fair.
- Content pipeline exists for waves/patterns.

**v0.2**
- Upgrade bar + 2 bell colors integrated.
- Enemy variety noticeably improved.

**v0.3**
- Stage 2 exists and Training Mode v1 (stage practice + unlocks) exists.

---

## 13. Open Questions

1. Exact mapping of bell colors → upgrade families (start with 2; expand later).
2. Upgrade bar UX: auto-advance vs manual selection vs hold-to-select.
3. Drone behavior scope for v1: follow+shoot only vs detach/attach.
4. Difficulty modes: whether to ship Beginner/Normal early.

---
