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
var is_dying: bool                   = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var explosion_sprite: AnimatedSprite2D = $ExplosionSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	half_size = GlobalUtils.get_script().half_size_of_collision_shape($CollisionShape2D)
	full_size = half_size * 2
	view_port_size = get_viewport_rect().size
	standby_time = Timer.new()
	standby_time.one_shot = true
	standby_time.connect("timeout", _on_standby_timeout)
	add_child(standby_time)
	initialize_enemy()

	area_entered.connect(_on_area_entered)
	add_to_group("enemies")

func _process(delta: float) -> void:
	# Early exit if enemy is dying
	if is_dying:
		return

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
	is_dying = false
	sprite.visible = true
	explosion_sprite.visible = false
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

func die() -> void:
	if is_dying:
		return

	# Mark as dying
	is_dying = true
	speed = 0

	# Disable collision
	collision_shape.set_deferred("disabled", true)

	# Play explosion animation
	sprite.visible = false
	explosion_sprite.visible = true
	explosion_sprite.play("explode")
	explosion_sprite.connect("animation_finished", _on_explosion_sprite_animation_finished)

func _on_explosion_sprite_animation_finished() -> void:
	# Remove enemy from scene after explosion animation
	queue_free()

func _on_area_entered(target: Node2D) -> void:
	# Bullet collision handling
	if target.is_in_group("bullets"):
		# Remove the bullet
		target.queue_free()
		# Explode the enemy
		die()

	# Player collision handling
	if target.is_in_group("player"):
		# Explode the enemy
		die()
		# Hide player
		target.hide()
		# TODO: Game over, or notify player of hit
