class_name OptionsMenu
extends Control

signal closed

@onready var back_button: Button = %BackButton


func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	back_button.call_deferred("grab_focus")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()
		get_viewport().set_input_as_handled()


func _on_back_pressed() -> void:
	closed.emit()
