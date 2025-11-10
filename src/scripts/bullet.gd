extends Area2D

@export var speed: float = 10.0

func _process(delta: float) -> void:
	# Move bullet upward
	position.y -= speed * delta
	
	# Clean up if bullet goes off-screen (simple bounds check)
	if position.y < -100:
		queue_free()

func _on_area_entered(target: Node2D) -> void:

	if target.is_in_group("enemies"):
		# explode the enemy
		target.explode()
		# Remove the bullet
		queue_free()	# Handle collision with enemies or other objects

	#queue_free()
