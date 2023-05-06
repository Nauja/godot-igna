# Display the state of the rover
class_name RoverState
extends Node

# Normal color of the movement counter
@export_subgroup("RoverState")
@export var _move_counter_normal: Color
# Color of the movement counter to indicate danger
@export var _move_counter_danger: Color
# Movement counter displayed only when on the map
@onready var _move_counter: Node = %MoveCounter
# Display the remaining number of movements
@onready var _move_counter_label: Label = %MoveCounterLabel


func _ready():
	LevelSignals.level_ready.connect(_refresh)
	RoverSignals.rover_entered.connect(_on_rover_entered)
	RoverSignals.rover_exited.connect(_on_rover_exited)
	RoverSignals.rover_moved.connect(_refresh)
	_on_rover_exited()


func _on_rover_entered():
	_move_counter.visible = false


func _on_rover_exited():
	_move_counter.visible = true


func _refresh():
	var rover = RoverSignals.get_rover()
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
