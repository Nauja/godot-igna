# Player related signals
extends Node

var _get_player: Callable
signal player_moved
signal player_interact


func reset() -> void:
	_get_player = Callable()


# Get the player instance
func get_player() -> Player:
	return _get_player.call() if _get_player else null


# Player moved by one tile
func notify_player_moved() -> void:
	emit_signal("player_moved")


# Player try to interact
func notify_player_interact() -> void:
	emit_signal("player_interact")
