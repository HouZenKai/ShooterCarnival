extends Control

## Path to the game scene.
@export_file("*.tscn") var game_scene_path: String = "res://scenes/main.tscn"

@onready var label_stats: Label = $MarginContainer/Panel/MarginContainer/VBoxContainer/LabelStats


func _ready() -> void:
	display_stats()


## Reads all GameStats properties and prints them in the UI Label.[br]
func display_stats():
	# An array to store every line to show in stats
	var formatted_lines: Array[String] = []
	# Getting the list of all the game stats
	var statistics = GameStats.get_display_stats()
	
	for stat in statistics:
		# Formats the line putting the stat name first and then the value on a new line
		var line := "%s\n%s" % [stat["label"], stat["value"]]
		formatted_lines.append(line)
	
	# Joining all lines with a new line
	label_stats.text = "\n".join(formatted_lines)


func _on_button_retry_pressed() -> void:
	get_tree().change_scene_to_file(game_scene_path)


func _on_button_exit_pressed() -> void:
	if OS.has_feature("web"):
		return
	get_tree().quit()
