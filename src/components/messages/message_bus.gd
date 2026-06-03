class_name MessageBus extends Resource
## A message bus for decoupled communication between components.[br]
## See script source for usage documentation.

# To receive a message (through a signal subscription):
# func _ready():
#    MessageBus.subscribe(Message.Type.ENEMY_DIED).connect(your_signal_handler)
#
# Your signal handler should have the signature:
# func your_signal_handler(payload:Message.Payload.EnemyDeath) -> void:
#    total_reward += payload.reward
#
# To send a message (through emitting a signal)
# func send_enemy_died_message() -> void:
#    var data : Message.Payload.EnemyDeath = Message.Payload.EnemyDeath.new(100)
#    MessageBus.publish(Message.Type.ENEMY_DIED, data)

# Holds instances of signals to avoild invalid references to Callables
## private, do not use outside of its script.
var _signal_proxy : Dictionary[Message.Type, MessageProxy] = {}


## Subscribe to a message type and get its signal.[br]
## @param type The message type to subscribe to.[br]
## @return The signal associated with the message type.[br]
func subscribe(type : Message.Type) -> Signal :
	if not _signal_proxy.has(type):
		# print_verbose("creating message proxy for type ", type)
		_signal_proxy[type] = MessageProxy.new()

	return _signal_proxy[type].callback


## Publish a message of a given type with the proper payload.[br]
## @param type The message type to publish.[br]
## @param payload The payload associated with the message.[br]
func publish(type : Message.Type, payload : Message.Payload) -> void:
	# var timestamp : String = GlobalUtils.timestamp_to_string(
	# 	Time.get_datetime_dict_from_system()
	# )
	# print_debug("Trying publish a message of TYPE ",type," at ",timestamp)

	if _signal_proxy.has(type):
		# print_debug("sending message of TYPE ",type," at ",timestamp)
		_signal_proxy[type].callback.emit(payload)

#	print_stack()

## Internal class to hold signals for message types.
class MessageProxy extends RefCounted:
	signal callback(payload : Message.Payload)
