# Manage the title screen
extends Node

# Messages to display
@export var _messages: Array[String]
# Label for displaying the current message
@onready var _message_label: Label = %Message
# Current displayed message
var _message_index: int = -1


func _ready():
	_next_message()


func _process(delta):
	# Display next message on user input
	if Input.is_action_just_pressed("action"):
		if not _next_message():
			# Load level screen when all messages have been displayed
			GameSignals.load_screen(Enums.EScreen.LEVEL)


# Display the next message and return true.
# Return false if there is no more message
func _next_message() -> bool:
	_message_index += 1
	if _message_index < len(_messages):
		_message_label.text = _messages[_message_index]
		return true

	return false
