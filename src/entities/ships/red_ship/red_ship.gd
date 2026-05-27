extends Area2D

@export var player_id: int = 1
@export var speed: float = 200.0 # Movement setting
@export var bullet_scene: PackedScene = preload("res://entities/bullets/double_bullet/double_bullet.tscn")
@export var health: HealthComponent = null

@onready var screen_rect: Vector2 = get_viewport_rect().size
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


var half_size: Vector2 = Vector2.ZERO
var can_shoot: bool = true
var is_immortal: bool = false

func _ready() -> void:
	half_size = GlobalUtils.half_size_of_collision_shape($CollisionShape2D)
	add_to_group("player")
	GlobalUtils.CombatBus\
		.subscribe(Message.Type.PLAYER_DAMAGED)\
		.connect(_hit)

func _physics_process(delta: float) -> void:
	# Get user input
	var input_vector : Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Movement to the right
	if input_vector.x > 0:
		$Ship.frame = 2
		$Ship/Boosters.animation = "right"

	# Movement to the left
	elif input_vector.x < 0:
		$Ship.frame = 0
		$Ship/Boosters.animation = "left"

	# Any other input (including no input)
	else:
		$Ship.frame = 1
		$Ship/Boosters.animation = "forward"


	# Move player
	position += input_vector * speed * delta

	# Clamp position to screen bounds (classic arcade style)
	position = position.clamp(half_size, screen_rect - half_size)

	# Handle firing
	shoot()

	immortal_mode()

## Shoots a projectile when the shoot action is pressed.
func shoot() -> void:

	# Immortal (debug) mode can detonate a "Ragnarok Bomb" that destroys all enemies on screen at anytime.
	if is_immortal and Input.is_action_just_pressed("immortal_ragnarok_bomb"):
		GlobalUtils.CombatBus.publish(
			Message.Type.RAGNAROK_BOMB_DROPPED,
			Message.Payload.NullPayload.new())
		return

	# If the player can't shoot, don't waste time checking for input
	if not can_shoot:
		return

	# If the shoot action isn't just pressed, exit early
	if not Input.is_action_just_pressed("shoot"):
		return

	# Play shooting SFX
	if $Shoot != null and !$Shoot.is_playing():
		$Shoot.play()

	var bullet_instance : Node2D = bullet_scene.instantiate()

	# It's often better to add bullets to the main scene tree or
	# to a dedicated bullets node in the main scene
	# rather than as a child of the player to avoid
	# transformation issues happening at the player level.

	#TODO: add bullets to a dedicated bullets node
	get_tree().root.add_child(bullet_instance)

	# Set bullet position to player's position
	bullet_instance.global_position = global_position

	# Offset to appear above the player
	bullet_instance.global_position.y = global_position.y - (half_size.y + 1)
	bullet_instance.scale = Vector2(1, 1)

	# print_debug("red_ship>>Fired a bullet from position: ", bullet_instance.global_position, global_position)

## Placeholder for temporary invulnerability behavior.
func immortal_mode() -> void:
	# Toggle immortal mode with a debug key (for testing purposes)
	if Input.is_action_just_pressed("immortal"):
		is_immortal = not is_immortal

	if is_immortal:
		modulate = Color(1, 1, 1, 0.5) # Semi-transparent to indicate invulnerability
	else:
		modulate = Color(1, 1, 1, 1) # Normal appearance


## Handles the player taking damage.
func _hit(_damage: Message.Payload.PlayerDamage) -> void:
	if is_immortal:
		return

	if _damage.is_instant_kill:
		health.instant_kill()
	else:
		health.damage(_damage.damage)

func _on_health_component_health_changed(change: HealthChange) -> void:
	# TODO: Handle player taking a hit (e.g., show damage, play animation, etc.)
	# print_debug("red_ship>>_on_health_component_health_changed Player took a hit! Health was ", change.previousHealth, " and now is ", change.currentHealth)
	pass

func _on_health_component_died() -> void:
	# print_debug("red_ship>>_on_health_component_died Player died!")
	# Disable and hide the player
	collision_shape.set_deferred("disabled", true)
	set_process(false)
	set_physics_process(false)
	hide()

	# Tell the world the player died (to update scores, stats, etc)
	GlobalUtils.CombatBus.publish(
		Message.Type.PLAYER_DIED,
		Message.Payload.PlayerDeath.new(player_id, position))
