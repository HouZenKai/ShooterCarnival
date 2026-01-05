@tool

"""
This component handles the health of an entity
"""

class_name HealthComponent extends Node

signal health_changed(change: HealthChange)
signal died()

@export var max_health: int = 1

var _current_health: int = 1
var _previous_health: int = 1

func _ready() -> void:
	_current_health = max_health
	_previous_health = _current_health

func set_max_health(new_max: int) -> void:
	max_health = new_max
	_current_health = clampi(_current_health, 0, max_health)

func damage(amount: int) -> void:
	_previous_health = _current_health
	_current_health = clampi(_current_health - amount, 0, max_health)

	health_changed.emit(_create_health_change_data())

	if _current_health == 0:
		died.emit()

func _create_health_change_data() ->  HealthChange:
	var change = HealthChange.new()
	change.previousHealth = _previous_health
	change.currentHealth = _current_health
	change.maxHealth = max_health
	return change
