# Signals related to the player in the rover
extends Node

var _get_player: Callable
signal player_moved
signal player_interact


func reset() -> void:
	_get_player = Callable()


# Get the player instance
var player: Player:
	get:
		return _get_player.call() if _get_player else null


# Notify when the player moved by one tile
func notify_player_moved() -> void:
	emit_signal("player_moved")


# Notify when the player pressed the action key
func notify_player_interact() -> void:
	emit_signal("player_interact")
