extends Area2D

@export var speed: float = 250.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	add_to_group("bullets")


func _process(delta: float) -> void:
	# Move bullet upward
	position.y -= speed * delta

	# Clean up if bullet goes off-screen (simple bounds check)
	if position.y < -32:
		queue_free()


func _on_area_entered(target: Node2D) -> void:

	if target.is_in_group("enemies"):
		# remove target from enemies group to prevent multiple hits
		target.remove_from_group("enemies")	
		target.die()
		queue_free()
