extends Node

var CombatBus = preload("res://resources/combat_bus.tres")

## Calculate the half size of a CollisionShape2D based on its shape type.[br]
## @param collision_shape The CollisionShape2D to evaluate.[br]
## @return The half size as a Vector2.[br]
func half_size_of_collision_shape(collision_shape: CollisionShape2D) -> Vector2:

	assert(collision_shape != null, "A collisionShape2D is required")
	assert(collision_shape.shape != null, "The CollisionShape2D requires a shape")

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

## Convert a timestamp dictionary to a formatted string.[br]
## @param timestamp A dictionary with year, month, day, hour, minute, second keys.[br]
## @return A formatted timestamp string.[br]
func timestamp_to_string(timestamp: Dictionary) -> String:
	return str(
		timestamp.year,
		timestamp.month,
		timestamp.day,
		"T",
		timestamp.hour,
		timestamp.minute,
		timestamp.second
	)
