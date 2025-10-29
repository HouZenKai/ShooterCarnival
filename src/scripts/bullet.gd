extends Area2D

@export var speed: float = 400.0

func _ready() -> void:
	# Connect to screen exited signal to clean up bullet when off-screen
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	# Move bullet upward
	position.y -= speed * delta
	
	# Clean up if bullet goes off-screen (simple bounds check)
	if position.y < -100:
		queue_free()

func _on_body_entered(_body: Node2D) -> void:
	# Handle collision with enemies or other objects
	queue_free()
