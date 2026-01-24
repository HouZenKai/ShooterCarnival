extends Node2D

@export var enemy_scene: PackedScene = preload("res://entities/enemies/jumping_enemy/enemy.tscn")
@export var spawn_interval: float = 1
@export var spawn_interval_decrement: float = 0.05

var timer: Timer = null
var minimum_spawn_interval: float = 0.050

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	GlobalUtils.CombatBus.subscribe(MessageBus.MessageType.ENEMY_DAMAGED).connect(_on_enemy_died)


# Timer timeout callback that triggers enemy spawning.
func _on_timer_timeout() -> void:
	spawn_enemy()


## Spawns a single enemy instance at a random position along the top of the screen.
func spawn_enemy() -> void:
	if enemy_scene:
		var enemy: Node2D = enemy_scene.instantiate()
		var screen_size = get_viewport_rect().size
		# Random position at top of screen
		var spawn_position := Vector2(randf_range(20, screen_size.x - 20), -20)
		if enemy.has_method("setup"):
			enemy.setup(spawn_position)
		else:
			enemy.position = spawn_position

		add_child(enemy)

func _on_enemy_died(_payload: MessagePayload.EnemyDamage) -> void:
	if spawn_interval >= minimum_spawn_interval:
		spawn_interval -= spawn_interval_decrement
		timer.wait_time = spawn_interval
		# print_debug("New spawn interval: ", timer.wait_time)
