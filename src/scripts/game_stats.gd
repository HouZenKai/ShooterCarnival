extends Node

var score: int = 0
var enemies_defeated: int = 0


func _ready() -> void:
	# Subscribe to receive enemy died messages
	GlobalUtils.CombatBus.subscribe(GlobalUtils.CombatBus.MessageType.ENEMY_DIED).connect(_on_enemy_died)


## This function is called every time an enemy dies and counts them.[br]
## @param payload The message payload. Contains the enemy reward.[br]
func _on_enemy_died(payload: MessagePayload.EnemyDeath) -> void:
	score += payload.reward
	enemies_defeated += 1


## Resets player stats.[br]
func reset() -> void:
	score = 0
	enemies_defeated = 0
