extends CanvasLayer
## HUD: Displays game UI including score and lives.
## Handles updating the score when enemies are destroyed.

@onready var score_label: Label = $Control/ScoreLabel

var current_score: int = 0


func _ready() -> void:
	update_score_display()


## Increment the score by the specified amount.
## @param points: The number of points to add to the score.
func add_score(points: int) -> void:
	current_score += points
	update_score_display()


## Reset the score to zero (useful for game restart).
func reset_score() -> void:
	current_score = 0
	update_score_display()


## Update the score label text to reflect the current score.
func update_score_display() -> void:
	score_label.text = "Score: %d" % current_score
