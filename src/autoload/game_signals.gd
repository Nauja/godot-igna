# Signals global to the game
extends Node

var _load_screen: Callable


# Load and display a new screen
func load_screen(id: Enums.EScreen) -> void:
	if _load_screen:
		_load_screen.call(id)
