extends Node2D

@export var enemy_scene: PackedScene = preload("res://entities/enemies/jumping_enemy/enemy.tscn")
@export var spawn_interval_decrement: float = 0.05
## Maximum number of enemies in a platoon
@export var max_platoon_size: int = 30
## Maximum number of enemies in a row to not exceed screen space
@export var max_enemies_in_row: int = 12
## The percentage increase of enemy speed
@export var speed_increase_step: float = 0.1

@onready var spawn_timer: Timer = $SpawnTimer

var minimum_spawn_interval : float = 0.050
var alive_enemies : int = 0
var speed_increase_total : float = 0.0
var platoon_spawning : bool = false


func _ready() -> void:
	_spawn_enemies_platoon_async()
	GlobalUtils.CombatBus.subscribe(MessageBus.MessageType.ENEMY_DIED).connect(_on_enemy_died)


## Spawns a platoon of enemies over multiple frames to avoid frame drops on game start.
## This creates a wave of enemies spread across the top of the screen.
func _spawn_enemies_platoon_async() -> void: #TODO Object Pool
	if platoon_spawning:
		return
	platoon_spawning = true

	var x_position: int = 20
	var y_position: int = 16
	speed_increase_total += speed_increase_step
	alive_enemies += max_platoon_size

	for i in max_platoon_size:
		var enemy_instance: Node2D = enemy_scene.instantiate()
		enemy_instance.increase_base_speed(speed_increase_total)
		enemy_instance.setup(Vector2(x_position, y_position))

		x_position += 18
		if (i + 1) % max_enemies_in_row == 0: # Prevent spawning enemies out of screen
			x_position = 20
			y_position -= 16

		add_child(enemy_instance)
		# Spread spawning across multiple frames to prevent stuttering
		await get_tree().process_frame

	platoon_spawning = false


# Timer timeout callback that triggers enemy spawning.
func _on_timer_timeout() -> void:
	spawn_enemy()


## Spawns a single enemy instance at a random position along the top of the screen.
func spawn_enemy() -> void:
	if enemy_scene:
		var enemy: Node2D = enemy_scene.instantiate()
		var screen_size = get_viewport_rect().size
		# Random position at top of screen
		var spawn_position := Vector2(randf_range(20, screen_size.x - 20), -10)
		enemy.increase_base_speed(speed_increase_total)
		if enemy.has_method("setup"):
			enemy.setup(spawn_position)
		else:
			enemy.position = spawn_position

		add_child(enemy)
		alive_enemies += 1


func _on_enemy_died(_payload: MessagePayload.EnemyDeath) -> void:
	alive_enemies -= 1
	if alive_enemies == 0:
		_spawn_enemies_platoon_async()

	print(alive_enemies)

	if spawn_timer.wait_time >= minimum_spawn_interval:
		spawn_timer.wait_time -= spawn_interval_decrement


func _on_despawn_area_area_entered(area: Area2D) -> void:
	alive_enemies -= 1
	if alive_enemies == 0:
		_spawn_enemies_platoon_async()

	print(alive_enemies)

	area.queue_free() #TODO reuse with object pool
