# Widget displaying the name of entity hovered by the cursor
class_name CursorHint
extends HBoxContainer

# Label for the hint
@onready var _cursor_hint_label: Label = %CursorHintLabel


func _ready():
	LevelSignals.level_ready.connect(_refresh)
	LevelSignals.map_changed.connect(_on_map_changed)
	LevelSignals.cursor_moved.connect(_refresh)
	RoverSignals.rover_moved.connect(_refresh)


# This widget is only visible on the world map
func _on_map_changed():
	visible = LevelSignals.map == Enums.EMap.WORLD
	_refresh()


# Get the entity hovered by the label
func _refresh():
	var cursor = LevelSignals.cursor
	if not cursor:
		return

	var entity = LevelSignals.get_entity(cursor.tile)
	if entity:
		visible = true
		_cursor_hint_label.text = entity.cursor_hint
	else:
		visible = false
