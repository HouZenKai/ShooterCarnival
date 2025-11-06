extends CharacterBody2D

@export var speed: float = 200.0 # Movement setting

var bullet_scene: PackedScene = preload("res://scenes/bullets/bullet.tscn")

var bullet_instance: Node2D = null # bullet fired
var half_size: Vector2 = Vector2.ZERO

func _ready() -> void:
	half_size = calculate_half_size()

func _physics_process(_delta: float) -> void:
	# Get input
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Set velocity based on input
	velocity = input_vector * speed

	# Move player
	move_and_slide()

	# Clamp position to screen bounds (classic arcade style)
	var screen_rect := get_viewport_rect()
	position.x = clamp(position.x, half_size.x, screen_rect.size.x - half_size.x)
	position.y = clamp(position.y, half_size.y, screen_rect.size.y - half_size.y)

	# Handle firing
	fire()


func calculate_half_size() -> Vector2:
	var collision_shape = $CollisionShape2D
	assert(collision_shape != null, "Player requires a CollisionShape2D child node")
	assert(collision_shape.shape != null, "CollisionShape2D requires a shape resource")

	# Handle different shape types
	if collision_shape.shape is RectangleShape2D:
		half_size = collision_shape.shape.size / 2.0

	elif collision_shape.shape is CircleShape2D:
		var radius: float = collision_shape.shape.radius
		half_size = Vector2(radius, radius)

	elif collision_shape.shape is CapsuleShape2D:
		half_size = Vector2(collision_shape.shape.radius, collision_shape.shape.height / 2.0)

	else:
		half_size = Vector2.ZERO # Default fallback

	return half_size

func fire() -> void:

	if Input.is_action_just_pressed("fire"):

		bullet_instance = bullet_scene.instantiate()
		# It's often better to add bullets to the main scene tree or
		# to a dedicated bullets node in the main scene
		# rather than as a child of the player to avoid
		# transformation issues happening at the player level.

		#TODO: add bullets to a dedicated bullets node
		get_tree().root.add_child(bullet_instance)

		# Set bullet position to player's position
		bullet_instance.global_position = global_position

		# Offset to appear above the player
		bullet_instance.global_position.y -= (half_size.y + 1)
		print_debug("Fired a bullet from position: ", bullet_instance.global_position)
