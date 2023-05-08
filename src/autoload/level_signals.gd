# Signals for inside a level
extends Node

signal level_ready
signal map_changed
var _get_map: Callable
var _tile_width: Callable
var _tile_height: Callable
var _width: Callable
var _height: Callable
var _get_cursor: Callable
var _compute_path: Callable
var _compute_range: Callable
var _is_walkable: Callable
signal cursor_moved
var _get_entity: Callable
var _game_over: Callable
var _enter_rocket: Callable
signal rocket_entered
var _open_dialogue: Callable
var _close_dialogue: Callable
var _set_dialogue: Callable
var _is_dialogue_open: Callable
signal human_rescued(sheet)
var _get_fire_progression: Callable
signal fire_progressed


func reset() -> void:
	_get_map = Callable()
	_tile_width = Callable()
	_tile_height = Callable()
	_width = Callable()
	_height = Callable()
	_get_cursor = Callable()
	_compute_path = Callable()
	_compute_range = Callable()
	_is_walkable = Callable()
	_get_entity = Callable()
	_game_over = Callable()
	_enter_rocket = Callable()
	_open_dialogue = Callable()
	_close_dialogue = Callable()
	_set_dialogue = Callable()
	_is_dialogue_open = Callable()
	_get_fire_progression = Callable()


# Notify when the level is ready
func notify_level_ready():
	emit_signal("level_ready")


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


# Notify that the current map changed
func notify_map_changed() -> void:
	emit_signal("map_changed")


# Get the current map
func get_map() -> Enums.EMap:
	return _get_map.call() if _get_map else Enums.EMap.WORLD


# Get the cursor instance
func get_cursor() -> Cursor:
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


func is_walkable(tile: Vector2i) -> bool:
	return _is_walkable.call(tile) if _is_walkable else false


func notify_cursor_moved():
	emit_signal("cursor_moved")


# Get the topmost entity on a tile
func get_entity(tile: Vector2i) -> Entity:
	return _get_entity.call(tile) if _get_entity else null


# Trigger the game over
func game_over() -> void:
	if _game_over:
		_game_over.call()


# Enter the rocket
func enter_rocket() -> void:
	if _enter_rocket:
		_enter_rocket.call()


func notify_rocket_entered() -> void:
	emit_signal("rocket_entered")


func open_dialogue() -> void:
	if _open_dialogue:
		_open_dialogue.call()


func close_dialogue() -> void:
	if _close_dialogue:
		_close_dialogue.call()


func set_dialogue(speaker: Entity, val: String) -> void:
	if _set_dialogue:
		_set_dialogue.call(speaker, val)


func is_dialogue_open() -> bool:
	return _is_dialogue_open.call() if _is_dialogue_open else false


func notify_human_rescued(sheet: FellowHumanSheet) -> void:
	emit_signal("human_rescued", sheet)


func get_fire_progression() -> int:
	return _get_fire_progression.call() if _get_fire_progression else 0


func notify_fire_progressed() -> void:
	emit_signal("fire_progressed")
