class_name PauseMenu
extends CanvasLayer

signal closed

@export_file("*.tscn") var main_menu_scene_path: String = "res://scenes/ui/main_menu.tscn"

@onready var resume_button: Button = %ResumeButton
@onready var restart_button: Button = %RestartButton
@onready var options_button: Button = %OptionsButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var exit_button: Button = %ExitButton

var is_open: bool = false


func _ready() -> void:
	# Start hidden
	hide()
	set_process_input(false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and is_open:
		close_menu()
		get_viewport().set_input_as_handled()


func open_menu() -> void:
	if is_open:
		return
	is_open = true
	get_tree().paused = true
	show()
	set_process_input(true)
	resume_button.grab_focus()


func close_menu() -> void:
	if not is_open:
		return
	is_open = false
	get_tree().paused = false
	hide()
	set_process_input(false)
	closed.emit()


func _on_resume_button_pressed() -> void:
	close_menu()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
	close_menu()


func _on_options_button_pressed() -> void:
	# TODO: Open options submenu
	pass


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_scene_path)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
