extends Area2D


@export var base_speed : int = 95
@export var speed_variation_min : int = 5
@export var speed_variation_max : int = 25
@export var reward_value : int = 100
@export var health : HealthComponent = null

var speed : int = 0
var standby_time : Timer = null
var half_size : Vector2 = Vector2.ZERO
var full_size : Vector2 = Vector2.ZERO
var view_port_size : Vector2 = Vector2.ZERO
var initial_position : Vector2 = Vector2.ZERO
var is_dying : bool = false

@onready var sprite : Sprite2D = $Sprite2D
@onready var explosion_sprite : AnimatedSprite2D = $ExplosionSprite
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

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
	# Ensure the enemy is/will be visible
	assert(position.x <= view_port_size.x)
	assert(initial_position.x <= view_port_size.x)

	# When "Ragnarok Bomb" (debug) is dropped, an enemy should die immediately regardless of its health
	GlobalUtils.CombatBus\
		.subscribe(Message.Type.RAGNAROK_BOMB_DROPPED)\
		.connect(_on_ragnarok)

func _on_ragnarok(_payload : Message.Payload.NullPayload) -> void:
	# Do not kill an enemy already dying
	if not is_dying:
		_on_health_component_died()


func _process(delta: float) -> void:
	# Early exit if enemy is dying
	if is_dying:
		return

	position.y += speed * delta
	# Enemies might have jumped over the despawner area if they have a very high speed.
	assert(position.y < view_port_size.y * 3)

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
	var pos : Vector2 = Vector2(
		# x position randomized within screen width bounds considering enemy width
		randf_range(0, view_port_size.x),
		# y position just above the visible screen considering enemy height
		(-full_size.y - 1)
	)
	pos.x = clamp(pos.x, half_size.x, view_port_size.x - half_size.x)
	return pos

func increase_base_speed(percent: float) -> void:
	base_speed = int(base_speed * (1.0 + percent))
	# print_debug("\t jumping_enemy>>increase_base_speed Base speed: ", base_speed)

func final_speed() -> int:
	return base_speed + randi_range(speed_variation_min, speed_variation_max)

func _on_standby_timeout() -> void:
	speed = final_speed()

func damage(damage_amount:int) -> void:
	# Do nothing when exploding
	if is_dying:
		return

	# The health component manages my health
	health.damage(damage_amount)

	# Tell subscribers that the enemy took damage
	GlobalUtils.CombatBus.publish(
		Message.Type.ENEMY_DAMAGED,
		Message.Payload.EnemyDamage.new(damage_amount)
	)

"""
when an enemy dies I create an explosion and stop the enemy from hurting the player
"""
func _on_health_component_died() -> void:

	# If I died I need flag that to change how other methods behave
	is_dying = true
	speed = 0

	# No collisions should happen while exploding
	collision_shape.set_deferred("disabled", true)

	# Play boom SFX
	if $AudioStreamPlayer != null:
		$AudioStreamPlayer.play()

	# Play explosion animation
	sprite.visible = false
	explosion_sprite.visible = true
	explosion_sprite.play("explode")

	await explosion_sprite.animation_finished

	# Tell the world the enemy died (to update scores, stats, etc)
	GlobalUtils.CombatBus.publish(
		Message.Type.ENEMY_DIED,
		Message.Payload.EnemyDeath.new(reward_value)
	)

	queue_free()

func _on_area_entered(target: Node2D) -> void:
	# print_debug("jumping_enemy>>_on_area_entered Hit: ", target.name)
	if target.is_in_group("player"):
		# Tell the world that the player was hit
		GlobalUtils.CombatBus.publish(
				Message.Type.PLAYER_DAMAGED,
				Message.Payload.PlayerDamage.new(99999999, true)
		)

		# When my (enemy) ship hits the player it is an instant death for me
		health.instant_kill()
