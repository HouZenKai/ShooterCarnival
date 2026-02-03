extends Node2D
## Stage 01: The first gameplay stage.
## This script manages stage-specific logic including initial enemy spawning.

## Maximum number of enemies to spawn at game start
@export var max_initial_enemies: int = 30

## Path to the game over scene.
@export_file("*.tscn") var game_over_scene_path: String = "res://scenes/ui/game_over.tscn"

## Enemy scene to spawn
var enemy_scene: PackedScene = preload("res://entities/enemies/jumping_enemy/enemy.tscn")

## Reference to the player (direct child of this stage)
@onready var player: Area2D = $Player
@onready var hud: CanvasLayer = $HUD


func _ready() -> void:
	GameStats.reset()
	GlobalUtils.CombatBus.subscribe(GlobalUtils.CombatBus.MessageType.ENEMY_DIED).connect(_on_enemy_died)
	GlobalUtils.CombatBus.subscribe(GlobalUtils.CombatBus.MessageType.PLAYER_DIED).connect(_on_player_died)
	_spawn_initial_enemies_async()


## Spawns initial enemies over multiple frames to avoid frame drops on game start.
## This creates a wave of enemies spread across the top of the screen.
func _spawn_initial_enemies_async() -> void:
	var x_position: int = 0
	for _i in max_initial_enemies:
		var enemy_instance: Node2D = enemy_scene.instantiate()
		enemy_instance.setup(Vector2(x_position, 16))
		x_position += 18
		add_child(enemy_instance)
		# Connect the enemy's destroyed signal to our score handler
		#enemy_instance.enemy_destroyed.connect(_on_enemy_destroyed)
		# Spread spawning across multiple frames to prevent stuttering
		await get_tree().process_frame


## Called when the player dies. Shows the Game Over scene.
## @param player: The Player node.
func _on_player_died(payload: MessagePayload.PlayerDeath) -> void:
	# Checks who is the dead player. Can be usefull in case of multiplayer.
	if payload.player == self.player:
		# Waiting some time to get the player realize that is dead...
		await get_tree().create_timer(1.0).timeout
		# Shows game over scene
		get_tree().change_scene_to_file(game_over_scene_path)


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
