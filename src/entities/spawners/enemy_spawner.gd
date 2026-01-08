extends Node2D

@export var enemy_scene: PackedScene = preload("res://entities/enemies/jumping_enemy/enemy.tscn")
@export var spawn_interval: float = 2.0

var timer: Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout() -> void:
	spawn_enemy()

func spawn_enemy() -> void:
	if enemy_scene:
		var enemy = enemy_scene.instantiate()
		var screen_size = get_viewport_rect().size
		# Random position at top of screen
		enemy.position = Vector2(randf_range(20, screen_size.x - 20), -20)
		
		# Add to main scene instead of spawner strictly, to avoid transform inheritance issues if spawner moves
		# but for now child is fine as spawner is likely static.
		# Actually, issue #68 says "instances the player, spawners, and UI".
		add_child(enemy)
