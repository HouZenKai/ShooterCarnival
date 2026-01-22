extends Resource
class_name MessageBus
## A message bus for decoupled communication between components.[br]
## See script source for usage documentation.

# To receive a message (through a signal subscription):
#
# func _ready():
#    MessageBus.subscribe(MessageType.ENEMY_DIED).connect(your_signal_handler)
#
# Your signal handler should have the signature:
#
# func your_signal_handler(payload:MessagePayload.EnemyDeath) -> void:
#    total_damage += payload.points # i.e.
#
# To send a message (through emitting a signal)
#
# func send_enemy_died_message() -> void:
#    var data = MessagePayload.EnemyDeath.new(100)
#    MessageBus.publish(MessageType.ENEMY_DIED, data)

# private, do not use outside of this script
# Holds instances of signals to avoild invalid references to Callables
var _signal_proxy:Dictionary[MessageType, MessageProxy] = {}


## Subscribe to a message type and get its signal.[br]
## @param type The message type to subscribe to.[br]
## @return The signal associated with the message type.[br]
func subscribe(type:MessageType) -> Signal:
   if not _signal_proxy.has(type):
      print("creating message proxy for type ", type)
      _signal_proxy[type] = MessageProxy.new()

   return _signal_proxy[type].callback


## Publish a message of a given type with the propoer payload.[br]
## @param type The message type to publish.[br]
## @param payload The payload associated with the message.[br]
func publish(type:MessageType, payload:MessagePayload) -> void:
   print("Trying publish a message of ", type)
   if _signal_proxy.has(type):
      print("sending message ", type)
      _signal_proxy[type].callback.emit(payload)


# Add new message types here as needed.
# Each message type should have a corresponding payload class in MessagePayload.gd.
## Known message types.[br]
enum MessageType {
   ENEMY_DIED = 1, # MessagePayload.EnemyDeath
}

## Internal class to hold signals for message types.
class MessageProxy extends RefCounted:
   signal callback(payload:MessagePayload)
