extends RefCounted
class_name MessagePayload

## Base class for message payloads used in the message bus system.
##
## Inherit from this class to create specific message payloads for different message types.
##

class EnemyDeath extends MessagePayload:
## Payload for when the enemy dies (MessageType.ENEMY_DIED).
	var points:int

	func _init(thePoints:int) -> void:
		self.points = thePoints

class PlayerDamage extends MessagePayload:
## Payload for when the player takes damage (MessageType.PLAYER_DAMAGED).
	var damage:int

	func _init(theDamage:int) -> void:
		self.damage = theDamage