extends Node2D
## Stage 01: The first gameplay stage.
## This script manages stage-specific logic including initial enemy spawning.

## Maximum number of enemies to spawn at game start
@export var max_initial_enemies: int = 30

## Enemy scene to spawn
var enemy_scene: PackedScene = preload("res://entities/enemies/jumping_enemy/enemy.tscn")

## Reference to the player (direct child of this stage)
@onready var player: Area2D = $Player


func _ready() -> void:
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
		# Spread spawning across multiple frames to prevent stuttering
		await get_tree().process_frame


## Returns the player node for external access (e.g., parallax tracking in main scene).
func get_player() -> Area2D:
	return player
