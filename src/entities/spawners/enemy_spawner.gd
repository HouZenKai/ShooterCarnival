extends Node2D

const DEFAULT_ENEMY_SCENE_PATH: String = "res://entities/enemies/jumping_enemy/jumping_enemy.tscn"

@export var enemy_scene: PackedScene = GlobalUtils.load_scene(DEFAULT_ENEMY_SCENE_PATH, "enemy_spawner")
@export var spawn_interval_decrement: float = 0.05
## Maximum number of enemies in a row to not exceed screen space
@export var max_enemies_in_row: int = 10
## The percentage increase of enemy speed
@export var speed_increase_step: float = 0.1

@onready var hud: Hud = $"../HUD"

var max_platoon_size: int:
	get:
		return 3 * max_enemies_in_row

var minimum_spawn_interval : float = 0.050
var alive_enemies : int = 0
var speed_increase_total : float = 0.0
var platoon_spawning : bool = false


func _ready() -> void:
	_spawn_enemies_platoon_async()
	GlobalUtils.CombatBus\
		.subscribe(Message.Type.ENEMY_DIED)\
		.connect(_on_enemy_died)


## Spawns a platoon of enemies over multiple frames to avoid frame drops on game start.
## This creates a wave of enemies spread across the top of the screen.
func _spawn_enemies_platoon_async() -> void: #TODO Object Pool
	if platoon_spawning:
		return

	# in case of the enemy scene being (or changed) blank in the Inspector
	if not enemy_scene:
		push_error("enemy_spawner>>_spawn_enemies_platoon_async>>Enemy scene is not set.")
		return

	platoon_spawning = true

	# print_debug("enemy_spawner>>_spawn_enemies_platoon_async Creating a new Platoon")

	var x_position: int = 8
	var y_position: int = 40
	speed_increase_total += speed_increase_step

	for i : int in max_platoon_size:
		var enemy_instance: Node2D = enemy_scene.instantiate()

		if enemy_instance.has_method("increase_base_speed"):
			enemy_instance.increase_base_speed(speed_increase_total)

		if enemy_instance.has_method("setup"):
			enemy_instance.setup(Vector2(x_position, y_position))
		else:
			enemy_instance.position = Vector2(x_position, y_position)

		x_position += 18
		if (i + 1) % max_enemies_in_row == 0: # Prevent spawning enemies out of screen
			x_position = 8
			y_position -= 16

		# print_debug("\tenemy_spawner>>_spawn_enemies_platoon_async Added a new enemy to the platoon")
		add_child(enemy_instance)
		alive_enemies += 1
		hud.increment_enemy()
	
	 	# Spread spawning across multiple frames to prevent stuttering
		await get_tree().process_frame

	# print_debug("enemy_spawner>>_spawn_enemies_platoon_async Platoon Created")
	platoon_spawning = false

func _on_enemy_died(_payload: Message.Payload.EnemyDeath) -> void:
	alive_enemies -= 1
	if alive_enemies == 0:
		_spawn_enemies_platoon_async()

	# print_debug("enemy_spawner>>_on_enemy_died>>Enemies alive: ", alive_enemies)

func _on_despawn_area_area_entered(enemy: Area2D) -> void:
	# print_debug("enemy_spawner>>_on_despawn_area_area_entered>>alive_enemies", alive_enemies)
	#alive_enemies -= 1
	#if alive_enemies == 0:
		#_spawn_enemies_platoon_async()

	enemy.position = enemy.initial_position
