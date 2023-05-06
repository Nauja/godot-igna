class_name CursorHint
extends HBoxContainer

# Label for the cursor hint
@onready var _cursor_hint_label: Label = %CursorHintLabel


func _ready():
	LevelSignals.level_ready.connect(_refresh)
	LevelSignals.cursor_moved.connect(_refresh)
	RoverSignals.rover_moved.connect(_refresh)
	RoverSignals.rover_entered.connect(_on_rover_entered)
	RoverSignals.rover_exited.connect(_on_rover_exited)


func _on_rover_entered():
	visible = false


func _on_rover_exited():
	visible = true
	_refresh()


func _refresh():
	var cursor = LevelSignals.get_cursor()
	if not cursor:
		return

	var entity = LevelSignals.get_entity(cursor.tile)
	if entity:
		visible = true
		_cursor_hint_label.text = entity.cursor_hint
	else:
		visible = false
