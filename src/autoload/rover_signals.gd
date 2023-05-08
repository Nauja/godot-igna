# Rover related signals
extends Node

var _get_rover: Callable
var _get_module: Callable
var _enter_rover: Callable
var _exit_rover: Callable
var _stop_rover: Callable
var _drop_bomb: Callable
var _is_bomb: Callable
var _remove_bomb: Callable
signal bomb_dropped
signal rover_moved
signal action_performed
signal rover_charge_changed
signal rover_integrity_changed
signal rover_charging
signal rover_hit


func reset() -> void:
	_get_rover = Callable()
	_get_module = Callable()
	_enter_rover = Callable()
	_exit_rover = Callable()
	_stop_rover = Callable()
	_drop_bomb = Callable()


# Get the rover instance
func get_rover() -> Rover:
	return _get_rover.call() if _get_rover else null


func get_module(val: Enums.EModule) -> Module:
	return _get_module.call(val) if _get_module else null


# Enter the rover and display the interior view
func enter_rover() -> void:
	if _enter_rover:
		_enter_rover.call()


# Exit the rover and display the map
func exit_rover() -> void:
	if _exit_rover:
		_exit_rover.call()


# Stop the rover if moving
func stop_rover() -> void:
	if _stop_rover:
		_stop_rover.call()


func notify_rover_moved():
	emit_signal("rover_moved")


func notify_action_performed():
	emit_signal("action_performed")


func notify_rover_charge_changed():
	emit_signal("rover_charge_changed")


func notify_rover_integrity_changed():
	emit_signal("rover_integrity_changed")


func notify_rover_charging():
	emit_signal("rover_charging")


func notify_rover_hit():
	emit_signal("rover_hit")


func drop_bomb():
	if _drop_bomb:
		_drop_bomb.call()


func is_bomb(tile: Vector2i) -> bool:
	return _is_bomb.call(tile) if _is_bomb else false


func remove_bomb(tile: Vector2i):
	if _remove_bomb:
		_remove_bomb.call(tile)


func notify_bomb_dropped():
	emit_signal("bomb_dropped")
