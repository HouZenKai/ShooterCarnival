extends Area2D


@export var base_speed: int = 95
@export var speed_variation_min: int = 5
@export var speed_variation_max: int = 25
@export var reward_value: int = 100

var speed: int = 0
var health: int = 1
var standby_time: Timer = null
var half_size: Vector2 = Vector2.ZERO
var full_size: Vector2 = Vector2.ZERO
var view_port_size: Vector2 = Vector2.ZERO
var initial_position: Vector2 = Vector2.ZERO
var is_dying: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var explosion_sprite: AnimatedSprite2D = $ExplosionSprite
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	half_size = GlobalUtils.half_size_of_collision_shape($CollisionShape2D)
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

func increase_base_speed(percent: float) -> void:
	base_speed *= (1.0 + percent)

func final_speed() -> int:
	return base_speed + randi_range(speed_variation_min, speed_variation_max)

func _on_standby_timeout() -> void:
	speed = final_speed()

func damage(damage_amount:int) -> void:
	if is_dying:
		return

	health -= damage_amount

	# Emit signal with points
	GlobalUtils.CombatBus.publish(
		MessageBus.MessageType.ENEMY_DAMAGED,
		MessagePayload.EnemyDamage.new(damage_amount)
	)

	if health > 0:
		return

	# Mark as dying
	is_dying = true
	speed = 0

	# Disable collision
	collision_shape.set_deferred("disabled", true)

	# Play boom SFX
	if $AudioStreamPlayer != null:
		$AudioStreamPlayer.play()


	# Play explosion animation
	sprite.visible = false
	explosion_sprite.visible = true
	explosion_sprite.play("explode")
	
	await explosion_sprite.animation_finished

	GlobalUtils.CombatBus.publish(
		MessageBus.MessageType.ENEMY_DIED,
		MessagePayload.EnemyDeath.new(reward_value)
	)

	queue_free()

func _on_area_entered(target: Node2D) -> void:
	#print_debug("Jumping enemy hit ", target.name)
	if target.is_in_group("player"):
		# Tell the world that the player was hit
		GlobalUtils.CombatBus.publish(
				MessageBus.MessageType.PLAYER_DAMAGED,
				MessagePayload.PlayerDamage.new(1)
		)

		# Enemy dies when hitting player
		damage(health)
