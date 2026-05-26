class_name Hud
extends CanvasLayer
## HUD: Displays game UI including score, lives and enemies alive.
## Handles updating the score when enemies are destroyed.

@onready var score_label: Label = $Control/ScoreLabel
@onready var enemies_label: Label = $Control/EnemiesLabel

var current_score: int = 0
var enemies_alive: int = 0

func _ready() -> void:
	update_score_display()
	update_enemy_label()


## Increment the score by the specified amount.
## @param points: The number of points to add to the score.
func add_score(points: int) -> void:
	current_score += points
	update_score_display()

## Useful for when a game restarts
## Reset the score to zero
## Reset the number of enemies alive to zero.
func reset_hud() -> void:
	current_score = 0
	update_score_display()
	enemies_alive = 0
	update_enemy_label()

## Update the score label text to reflect the current score.
func update_score_display() -> void:
	if score_label:
		score_label.text = "Score: %d" % current_score

## Increment the number of enemies alive.
func increment_enemy() -> void:
	enemies_alive += 1
	update_enemy_label()

## Decrement the number of enemies alive.
func decrement_enemy() -> void:
	enemies_alive -= 1
	update_enemy_label()

## Update the enemies label text to reflect the current number of enemies alive.
func update_enemy_label() -> void:
	if enemies_label:
		enemies_label.text = "Alive: %d" % enemies_alive
