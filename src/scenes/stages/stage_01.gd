extends Node2D
## Stage 01: The first gameplay stage.
## This script manages stage-specific logic including initial enemy spawning.

## Delay time is seconds from player death to game over scene transition
@export var death_delay: float = 1.0

## Maximum number of enemies to spawn at game start
@export var max_initial_enemies: int = 30

## Path to the game over scene.
@export_file("*.tscn") var game_over_scene_path: String = "res://scenes/ui/game_over.tscn"

## Reference to the player (direct child of this stage)
@onready var player: Area2D = $Player
@onready var hud: CanvasLayer = $HUD


func _ready() -> void:
	GameStats.reset()
	GlobalUtils.CombatBus.subscribe(GlobalUtils.CombatBus.MessageType.ENEMY_DIED).connect(_on_enemy_died)
	GlobalUtils.CombatBus.subscribe(GlobalUtils.CombatBus.MessageType.PLAYER_DIED).connect(_on_player_died)


## Called when the player dies. Shows the Game Over scene.
## @param player: The Player node.
func _on_player_died(payload: MessagePayload.PlayerDeath) -> void:
	# Waiting some time to get the player realize that is dead...
	await get_tree().create_timer(death_delay).timeout
	# Shows game over scene
	SceneTransition.transition_to_scene(game_over_scene_path)


## Called when an enemy is destroyed. Adds points to the score.
## @param points: The point value of the destroyed enemy.
func _on_enemy_died(enemy: MessagePayload.EnemyDeath) -> void:
	if hud and is_instance_valid(hud):
		hud.add_score(enemy.reward)


## Returns the player node for external access (e.g., parallax tracking in main scene).
## Returns null if the player has been freed or is invalid.
func get_player() -> Area2D:
	if is_instance_valid(player):
		return player
	return null
