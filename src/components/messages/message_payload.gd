extends RefCounted
class_name MessagePayload

## Base class for message payloads used in the message bus system.
##
## Inherit from this class to create specific message payloads for different message types.
##

class EnemyDamage extends MessagePayload:
## Payload for when the enemy takes damage (MessageType.ENEMY_DAMAGED).
	var damage:int

	func _init(theDamage:int) -> void:
		self.damage = theDamage

class EnemyDeath extends MessagePayload:
## Payload for when the enemy dies (MessageType.ENEMY_DIED).
	var reward:int

	func _init(theReward:int) -> void:
		self.reward = theReward

class PlayerDamage extends MessagePayload:
## Payload for when the player takes damage (MessageType.PLAYER_DAMAGED).
	var damage:int

	func _init(theDamage:int) -> void:
		self.damage = theDamage

class PlayerDeath extends MessagePayload:
## Payload for when the player dies (MessageType.PLAYER_DIED).
	var player_id: int
	var final_position: Vector2

	func _init(thePlayerId: int, position: Vector2 = Vector2.ZERO) -> void:
		self.player_id = thePlayerId
		self.final_position = position
