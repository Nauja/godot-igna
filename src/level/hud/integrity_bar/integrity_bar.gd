class_name IntegrityBar
extends Node

# Module to display
@export_subgroup("IntegrityBar")
@export var module: Enums.EModule:
	get:
		return module
	set(val):
		module = val
		_refresh()
# Slots of the bar
@export var _slot_paths: Array[NodePath]
var _slots: Array[ColorRect]
# Color for the bar filled
@export_subgroup("Theme")
@export var _bar_filled: Color
# Color for when the bar is not filled
@export var _bar_warning: Color
# Color for when the bar is almost empty
@export var _bar_danger: Color
# Color for empty slots
@export var _slot_empty: Color
# Integrity level
var value: int:
	get:
		var m = RoverSignals.get_module(module)
		return m.integrity if m else 0


func _ready():
	LevelSignals.level_ready.connect(_refresh)
	RoverSignals.rover_integrity_changed.connect(_refresh)
	# Gather slots
	_slots = []
	for slot_path in _slot_paths:
		_slots.append(get_node(slot_path))


func _refresh():
	var level = value
	var size = len(_slots)
	var color = _bar_filled if level >= size else (_bar_danger if level <= 1 else _bar_warning)
	for i in range(size):
		_slots[i].color = color if i < level else _slot_empty
