## Known message types.[br]
class_name Message extends RefCounted

# Add new message types here as needed.
## Each message type should have a payload subclass associated to it
enum Type {
	## This type uses Payload.EnemyDamage
	ENEMY_DAMAGED = 1,
	## This type uses Payload.EnemyDeath
	ENEMY_DIED,
	## This type uses Payload.PlayerDamage
	PLAYER_DAMAGED,
	## This type uses Payload.PlayerDeath
	PLAYER_DIED,
	## This type uses Payload.NullPayload
	RAGNAROK_BOMB_DROPPED,
}

class Payload extends RefCounted :
## Base class for message payloads used in the message bus.
##
## Inherit from this class to create specific message payloads for different message types.
##

	## A payload for messages that do not require any data.
	class NullPayload extends Payload:
		pass

	## Payload for messages of Type.ENEMY_DAMAGED emitted when the enemy takes damage.
	class EnemyDamage extends Payload:
		var damage : int

		func _init(theDamage : int) -> void:
			self.damage = theDamage

	## Payload for messages of Type.ENEMY_DIED emitted when the enemy dies.
	class EnemyDeath extends Payload:
		var reward : int

		func _init(theReward : int) -> void:
			self.reward = theReward

	## Payload for messages of Type.PLAYER_DAMAGED emitted when the player takes damage.
	class PlayerDamage extends Payload:
		var damage :int
		var is_instant_kill : bool

		func _init(theDamage:int, instantKill: bool = false) -> void:
			self.damage = theDamage
			self.is_instant_kill = instantKill

	## Payload for messages of Type.PLAYER_DIED emitted when the player dies.
	class PlayerDeath extends Payload:
		var player_id: int
		var final_position: Vector2

		func _init(thePlayerId: int, position: Vector2 = Vector2.ZERO) -> void:
			self.player_id = thePlayerId
			self.final_position = position
