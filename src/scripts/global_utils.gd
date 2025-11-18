extends Node

static func half_size_of_collision_shape(collision_shape: CollisionShape2D) -> Vector2:

	assert(collision_shape != null, "Player requires a CollisionShape2D child node")
	assert(collision_shape.shape != null, "CollisionShape2D requires a shape resource")

	var half_size: Vector2 = Vector2.ZERO

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
