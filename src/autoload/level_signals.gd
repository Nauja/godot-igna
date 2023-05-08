# Signals global to a level
extends Node

signal level_ready
# For the map
signal map_changed
var _get_map: Callable
var _tile_width: Callable
var _tile_height: Callable
var _width: Callable
var _height: Callable
var _get_entities: Callable
var _get_entity: Callable
# For the rover
var _enter_rover: Callable
var _exit_rover: Callable
var _enter_rocket: Callable
var _drop_bomb: Callable
var _is_bomb: Callable
var _remove_bomb: Callable
signal bomb_dropped
# For the cursor and A*
var _get_cursor: Callable
var _compute_path: Callable
var _compute_range: Callable
var _is_walkable: Callable
signal cursor_moved
# For the dialogue
var _open_dialogue: Callable
var _close_dialogue: Callable
var _set_dialogue: Callable
var _is_dialogue_open: Callable
# Other
signal human_rescued(sheet)
var _get_fire_progression: Callable
signal fire_progressed
var _game_over: Callable


func reset() -> void:
	# For the map
	_get_map = Callable()
	_tile_width = Callable()
	_tile_height = Callable()
	_width = Callable()
	_height = Callable()
	_get_entities = Callable()
	_get_entity = Callable()
	# For the rover
	_enter_rover = Callable()
	_exit_rover = Callable()
	_enter_rocket = Callable()
	_drop_bomb = Callable()
	_is_bomb = Callable()
	_remove_bomb = Callable()
	# For the cursor and A*
	_get_cursor = Callable()
	_compute_path = Callable()
	_compute_range = Callable()
	_is_walkable = Callable()
	# For the dialogue
	_open_dialogue = Callable()
	_close_dialogue = Callable()
	_set_dialogue = Callable()
	_is_dialogue_open = Callable()
	# Other
	_game_over = Callable()
	_get_fire_progression = Callable()


# Notify when the level is ready
func notify_level_ready():
	emit_signal("level_ready")


# Notify that the current map changed
func notify_map_changed() -> void:
	emit_signal("map_changed")


# Get the current map
var map: Enums.EMap:
	get:
		return _get_map.call() if _get_map else Enums.EMap.WORLD

# Width of the level in tiles
var tile_width: int:
	get:
		return _tile_width.call() if _tile_width else 0

# Height of the level in tiles
var tile_height: int:
	get:
		return _tile_height.call() if _tile_height else 0

# Width of the level in pixels
var width: int:
	get:
		return _width.call() if _width else 0

# Height of the level in pixels
var height: int:
	get:
		return _height.call() if _height else 0


# Enter the rover and display the rover map
func enter_rover() -> void:
	if _enter_rover:
		_enter_rover.call()


# Exit the rover and display the world map
func exit_rover() -> void:
	if _exit_rover:
		_exit_rover.call()


# Enter the rocket and display the rocket map
func enter_rocket() -> void:
	if _enter_rocket:
		_enter_rocket.call()


# Drop a bomb on the world map
func drop_bomb():
	if _drop_bomb:
		_drop_bomb.call()


# Check if a tile contains a bomb
func is_bomb(tile: Vector2i) -> bool:
	return _is_bomb.call(tile) if _is_bomb else false


# Remove a bomb from the world map
func remove_bomb(tile: Vector2i):
	if _remove_bomb:
		_remove_bomb.call(tile)


# Notify when a bomb has been dropped
func notify_bomb_dropped():
	emit_signal("bomb_dropped")


# Get the cursor instance
var cursor: Cursor:
	get:
		return _get_cursor.call() if _get_cursor else null


# Compute a path between two tiles
func compute_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	if _compute_path:
		return _compute_path.call(from, to)

	var l: Array[Vector2i] = []
	return l


# Compute an accessibility range
func compute_range(center: Vector2i, distance: int) -> Array[Vector2i]:
	if _compute_range:
		return _compute_range.call(center, distance)

	var l: Array[Vector2i] = []
	return l


# Check if a tile of the current map is walkable
func is_walkable(tile: Vector2i) -> bool:
	return _is_walkable.call(tile) if _is_walkable else false


# Notify when the cursor moved by one tile
func notify_cursor_moved():
	emit_signal("cursor_moved")


# Get all entities on the current map
var entities: Array[Entity]:
	get:
		if _get_entities:
			return _get_entities.call()

		var result: Array[Entity] = []
		return result


# Get the topmost entity on a tile
func get_entity(tile: Vector2i) -> Entity:
	return _get_entity.call(tile) if _get_entity else null


# Trigger the game over
func game_over() -> void:
	if _game_over:
		_game_over.call()


# Open the dialogue box
func open_dialogue() -> void:
	if _open_dialogue:
		_open_dialogue.call()


# Close the dialogue box
func close_dialogue() -> void:
	if _close_dialogue:
		_close_dialogue.call()


# Set the text for the dialogue
func set_dialogue(speaker: Entity, val: String) -> void:
	if _set_dialogue:
		_set_dialogue.call(speaker, val)


# Get if the dialogue is open
func is_dialogue_open() -> bool:
	return _is_dialogue_open.call() if _is_dialogue_open else false


# Notify when a fellow human has been rescued
func notify_human_rescued(sheet: FellowHumanSheet) -> void:
	emit_signal("human_rescued", sheet)


# Get the fire progression
func get_fire_progression() -> int:
	return _get_fire_progression.call() if _get_fire_progression else 0


# Notify when the fire progressed by one tile
func notify_fire_progressed() -> void:
	emit_signal("fire_progressed")
