extends Node2D

@export var enemy_scene: PackedScene = preload("res://entities/enemies/jumping_enemy/enemy.tscn")
@export var spawn_interval: float = 2.0

var timer: Timer = null


func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)


# Timer timeout callback that triggers enemy spawning.
func _on_timer_timeout() -> void:
	spawn_enemy()


func spawn_enemy() -> void:
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		var screen_size = get_viewport_rect().size
		# Random position at top of screen
		var spawn_position := Vector2(randf_range(20, screen_size.x - 20), -20)
		if enemy.has_method("setup"):
			enemy.setup(spawn_position)
		else:
			enemy.position = spawn_position
		
		# Add to parent (Stage01) so it can connect the enemy_destroyed signal
		get_parent().add_child(enemy)
		
		# Connect the signal if the parent has the handler
		if get_parent().has_method("_on_enemy_destroyed"):
			enemy.enemy_destroyed.connect(get_parent()._on_enemy_destroyed)
