extends Area2D

@export var base_speed: int          = 95
@export var speed_variation_min: int = 5
@export var speed_variation_max: int = 25

var speed: int                       = 0
var standby_time: Timer              = null
var half_size: Vector2               = Vector2.ZERO
var full_size: Vector2               = Vector2.ZERO
var view_port_size: Vector2          = Vector2.ZERO
var initial_position: Vector2        = Vector2.ZERO

func _ready() -> void:
	half_size = GlobalUtils.get_script().half_size_of_collision_shape($CollisionShape2D)
	full_size = half_size * 2
	view_port_size = get_viewport_rect().size
	standby_time = Timer.new()
	standby_time.one_shot = true
	standby_time.connect("timeout", _on_standby_timeout)
	add_child(standby_time)
	initialize_enemy()

func _process(delta: float) -> void:
	position.y += speed * delta
	# Check if enemy has moved off the bottom of the screen
	if position.y > (view_port_size.y + full_size.y + 1):
		initialize_enemy()

func setup(pos: Vector2) -> void:
	initial_position = pos

func initialize_enemy() -> void:
	if initial_position:
		position = initial_position
	else:
		position = randomize_initial_position()
	speed = 0
	standby_time.wait_time = randf_range(0.5, 2.5)
	standby_time.start()

func randomize_initial_position() -> Vector2:
	var pos = Vector2(
		# x position randomized within screen width bounds considering enemy width
		randf_range(0, view_port_size.x),
		# y position just above the visible screen considering enemy height
		(-full_size.y - 1)
	)
	pos.x = clamp(pos.x, half_size.x, view_port_size.x - half_size.x)
	return pos

func final_speed() -> int:
	return base_speed + randi_range(speed_variation_min, speed_variation_max)

func _on_standby_timeout() -> void:
	speed = final_speed()
