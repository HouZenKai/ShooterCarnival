class_name MainMenu
extends Control
## Main Menu scene - based on Maaack's Game Template architecture.
## Provides navigation to game, options, credits, and exit.

signal sub_menu_opened
signal sub_menu_closed
signal game_started
signal game_exited

## Path to the game scene. Hides play button if empty.
@export_file("*.tscn") var game_scene_path: String = "res://scenes/main.tscn"
## Scene to open when player clicks 'Options' button.
@export var options_packed_scene: PackedScene
## Scene to open when player clicks 'Credits' button.
@export var credits_packed_scene: PackedScene

var sub_menu: Control

@onready var menu_container = %MenuContainer
@onready var menu_buttons_box_container = %MenuButtonsBoxContainer
@onready var new_game_button = %NewGameButton
@onready var options_button = %OptionsButton
@onready var credits_button = %CreditsButton
@onready var exit_button = %ExitButton


func _ready() -> void:
	_hide_exit_for_web()
	_hide_options_if_unset()
	_hide_credits_if_unset()
	_hide_new_game_if_unset()


func load_game_scene() -> void:
	get_tree().change_scene_to_file(game_scene_path)


func new_game() -> void:
	load_game_scene()


func exit_game() -> void:
	if OS.has_feature("web"):
		return
	get_tree().quit()


func _open_sub_menu(menu: PackedScene) -> Node:
	sub_menu = menu.instantiate()
	add_child(sub_menu)
	menu_container.hide()
	# Support both 'closed' and 'hidden' signals for sub-menu closure
	if sub_menu.has_signal("closed"):
		sub_menu.closed.connect(_close_sub_menu, CONNECT_ONE_SHOT)
	else:
		sub_menu.hidden.connect(_close_sub_menu, CONNECT_ONE_SHOT)
	sub_menu_opened.emit()
	return sub_menu


func _close_sub_menu() -> void:
	if sub_menu == null:
		return
	sub_menu.queue_free()
	sub_menu = null
	menu_container.show()
	sub_menu_closed.emit()


func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		if sub_menu:
			_close_sub_menu()
			get_viewport().set_input_as_handled()
		else:
			exit_game()
			get_viewport().set_input_as_handled()
func _hide_exit_for_web() -> void:
	if OS.has_feature("web"):
		exit_button.hide()


func _hide_new_game_if_unset() -> void:
	if game_scene_path.is_empty():
		new_game_button.hide()


func _hide_options_if_unset() -> void:
	if options_packed_scene == null:
		options_button.hide()


func _hide_credits_if_unset() -> void:
	if credits_packed_scene == null:
		credits_button.hide()


func _on_new_game_button_pressed() -> void:
	new_game()


func _on_options_button_pressed() -> void:
	_open_sub_menu(options_packed_scene)


func _on_credits_button_pressed() -> void:
	_open_sub_menu(credits_packed_scene)


func _on_exit_button_pressed() -> void:
	exit_game()
