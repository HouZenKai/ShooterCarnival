extends CharacterBody2D

@export var speed: float = 200.0 # Movement setting

func _physics_process(_delta: float) -> void:
	# Get input
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Set velocity based on input
	velocity = input_vector * speed
	
	# Move player
	move_and_slide()

	# Clamp position accounting for collision shape bounds
	var screen_rect = get_viewport_rect()
	var collision_shape = $CollisionShape2D
	assert(collision_shape != null, "Player requires a CollisionShape2D child node")
	assert(collision_shape.shape != null, "CollisionShape2D requires a shape resource")
	
	var half_size := Vector2.ZERO
	# Handle different shape types
	if collision_shape.shape is RectangleShape2D:
		half_size = collision_shape.shape.size / 2.0
	elif collision_shape.shape is CircleShape2D:
		var radius = collision_shape.shape.radius
		half_size = Vector2(radius, radius)
	elif collision_shape.shape is CapsuleShape2D:
		half_size = Vector2(collision_shape.shape.radius, collision_shape.shape.height / 2.0)
	
	position.x = clamp(position.x, half_size.x, screen_rect.size.x - half_size.x)
	position.y = clamp(position.y, half_size.y, screen_rect.size.y - half_size.y)
