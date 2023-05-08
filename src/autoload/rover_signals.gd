# Signals related to the rover on the world map
extends Node

var _get_rover: Callable
var _get_module: Callable
var _stop_rover: Callable
signal rover_moved
signal action_performed
signal rover_charge_changed
signal rover_integrity_changed
signal rover_charging
signal rover_hit


func reset() -> void:
	_get_rover = Callable()
	_get_module = Callable()
	_stop_rover = Callable()


# Get the rover instance
var rover: Rover:
	get:
		return _get_rover.call() if _get_rover else null


# Get the instance of a module
func get_module(val: Enums.EModule) -> Module:
	return _get_module.call(val) if _get_module else null


# Stop the rover if moving
func stop_rover() -> void:
	if _stop_rover:
		_stop_rover.call()


# Notify when the rover moved by one tile
func notify_rover_moved():
	emit_signal("rover_moved")


# Notify when the rover performed an action
func notify_action_performed():
	emit_signal("action_performed")


# Notify when the charge level of any module changed
func notify_rover_charge_changed():
	emit_signal("rover_charge_changed")


# Notify when the integrity level of any module changed
func notify_rover_integrity_changed():
	emit_signal("rover_integrity_changed")


# Notify when the rover starts charging
func notify_rover_charging():
	emit_signal("rover_charging")


# Notify when the rover gets hit
func notify_rover_hit():
	emit_signal("rover_hit")
