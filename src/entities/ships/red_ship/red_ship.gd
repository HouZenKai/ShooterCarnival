extends Area2D

@export var speed: float = 200.0 # Movement setting
@export var bullet_scene: PackedScene = preload("res://entities/bullets/double_bullet/double_bullet.tscn")
@export var health: HealthComponent = null

@onready var screen_rect: Vector2 = get_viewport_rect().size


var half_size: Vector2 = Vector2.ZERO
var can_shoot: bool = true

func _ready() -> void:
	half_size = GlobalUtils.get_script().half_size_of_collision_shape($CollisionShape2D)
	add_to_group("player")

func _physics_process(delta: float) -> void:
	# Get user input
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")

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

func shoot() -> void:

	if can_shoot and Input.is_action_just_pressed("shoot"):

		var bullet_instance = bullet_scene.instantiate()
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

		print_debug("Fired a bullet from position: ", bullet_instance.global_position, global_position)

func hit(_damage: int) -> void:
	health.damage(_damage)

func _on_health_component_health_changed(change: HealthChange) -> void:
	# Handle player taking a hit (e.g., reduce health, play animation, etc.)
	print_debug("Player took a hit! Health was ", change.previousHealth, "and now is ", change.currentHealth)

func _on_health_component_died() -> void:
	# For now, destroy the player on any hit
	print_debug("Player died!")
	queue_free()
	can_shoot = false
