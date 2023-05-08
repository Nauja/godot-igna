# Widget displaying the state of the rover and the move counter
class_name RoverState
extends Node

# Normal color of the move counter
@export_subgroup("RoverState")
@export var _move_counter_normal: Color
# Color of the move counter to indicate danger
@export var _move_counter_danger: Color
# Root of the move counter
@onready var _move_counter: Node = %MoveCounter
# Display the number of remaining moves
@onready var _move_counter_label: Label = %MoveCounterLabel


func _ready():
	LevelSignals.level_ready.connect(_refresh)
	LevelSignals.map_changed.connect(_on_map_changed)
	RoverSignals.rover_moved.connect(_refresh)
	_on_map_changed()


# The move counter is only visible on the world map
func _on_map_changed():
	_move_counter.visible = LevelSignals.map == Enums.EMap.WORLD


# Update the move counter
func _refresh():
	var rover = RoverSignals.rover
	if not rover:
		return

	var max_move_count = rover.max_move_count
	var move_count = rover.move_count
	_move_counter_label.text = str(max_move_count - (move_count % max_move_count))
	_move_counter_label.add_theme_color_override(
		"font_color",
		(
			_move_counter_danger
			if (max_move_count - (move_count % max_move_count)) < 4
			else _move_counter_normal
		)
	)
