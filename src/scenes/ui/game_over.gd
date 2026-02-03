extends Control

## Path to the game scene.
@export_file("*.tscn") var game_scene_path: String = "res://scenes/main.tscn"


func _on_button_retry_pressed() -> void:
	get_tree().change_scene_to_file(game_scene_path)


func _on_button_exit_pressed() -> void:
	if OS.has_feature("web"):
		return
	get_tree().quit()
