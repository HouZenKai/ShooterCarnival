extends CharacterBody2D

@export var speed: float = 200.0 # Movement setting

func _physics_process(delta: float) -> void:
	# Get input
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Set velocity based on input
	velocity = input_vector * speed
	
	# Move player
	move_and_slide()

	# Clamp position
	var screen_rect = get_viewport_rect()
	position.x = clamp(position.x, 0.0, screen_rect.size.x)
	position.y = clamp(position.y, 0.0, screen_rect.size.y)
