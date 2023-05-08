# Controller for when on the world map.
# The rover is controlled as in a tactical game
class_name WorldController
extends Controller

enum _EInputMode { GAMEPAD, MOUSE }

# Instance of the cursor
@export_subgroup("Controller")
@export_node_path("Cursor") var _cursor_path: NodePath
@onready var _cursor: Cursor = get_node(_cursor_path)
# Instance of the rover
@export_node_path("Rover") var _rover_path: NodePath
@onready var _rover: Rover = get_node(_rover_path)
# Tile map to display the movements
@export_node_path("TileMap") var _movement_tile_map_path: NodePath
@onready var _movement_tile_map: TileMap = get_node(_movement_tile_map_path)
# Grey tile in the movement tile map
@export var _grey_tile: Vector2i
# Blue tile in the movement tile map
@export var _blue_tile: Vector2i
# White tile in the movement tile map
@export var _white_tile: Vector2i
# Red tile in the movement tile map
@export var _red_tile: Vector2i
# How fast input are repeated when pressed down
@export var _input_repeat: float
# Time to wait before next input
var _input_delay: float
# Desired tile for the cursor
var _desired_cursor_tile: Vector2i
# Last input mode
var _input_mode: _EInputMode = _EInputMode.GAMEPAD
# Computed accessibility range
var _range: Array[Vector2i] = []
# Computed path
var _path: Array[Vector2i] = []
# Remaining range to move
var _remaining_range: int


func _ready():
	_map = Enums.EMap.WORLD
	_allow_diagonals = true
	super()
	RoverSignals.rover_charging.connect(_stop_rover)
	RoverSignals.rover_hit.connect(_stop_rover)
	_cursor.tile = _rover.tile
	_desired_cursor_tile = _rover.tile


func _on_level_ready():
	_stop_rover()


func _stop_rover():
	_update_path(true)
	_refresh()


func _input(event):
	if not _rover.is_moving and event is InputEventMouseMotion:
		_input_mode = _EInputMode.MOUSE


func _process(delta):
	super(delta)
	if LevelSignals.is_dialogue_open():
		return

	if not _rover.is_moving:
		_process_cursor_select(delta)


func _physics_process(delta):
	if LevelSignals.is_dialogue_open():
		return

	if _rover.is_moving and not _rover.is_paused:
		_physics_process_rover_move(delta)


# Update the cursor selection
func _process_cursor_select(delta):
	var dir = input_direction

	if _input_delay >= 0:
		_input_delay -= delta

	if dir.x != 0 or dir.y != 0:
		_input_mode = _EInputMode.GAMEPAD
		if _input_delay <= 0:
			_input_delay = _input_repeat
			_desired_cursor_tile = _desired_cursor_tile + dir

	if _input_mode == _EInputMode.MOUSE:
		_desired_cursor_tile = Utils.world_to_tile(get_global_mouse_position())

	_desired_cursor_tile.x = clampi(_desired_cursor_tile.x, 0, LevelSignals.tile_width - 1)
	_desired_cursor_tile.y = clampi(_desired_cursor_tile.y, 0, LevelSignals.tile_height - 1)
	if _desired_cursor_tile != _cursor.tile:
		_cursor.tile = _desired_cursor_tile
		if _desired_cursor_tile != _rover.tile:
			_update_path(false)
		_refresh()
		LevelSignals.notify_cursor_moved()

	if Input.is_action_pressed("bomb"):
		RoverSignals.drop_bomb()

	if Input.is_action_just_pressed("action"):
		if _cursor.tile == _rover.tile:
			RoverSignals.enter_rover()
		elif len(_path) != 0 and _rover.range > 0:
			# Accept movement only if there is a valid path
			_remaining_range = _rover.range
			_rover.set_charging(false)
			_rover.is_moving = true
			_refresh()


# Update the rover movement
func _physics_process_rover_move(delta):
	if not _rover.is_moving or _remaining_range <= 0 or len(_path) == 0:
		_rover.is_moving = false
		_update_path(true)
		_refresh()
		return

	var next_tile = _path[0]
	var world_position = Utils.tile_to_world(next_tile)
	var dir: Vector2 = world_position - _rover.global_position

	if dir.x > 0:
		_rover.direction = Enums.EDirection.RIGHT
	elif dir.x < 0:
		_rover.direction = Enums.EDirection.LEFT
	elif dir.y > 0:
		_rover.direction = Enums.EDirection.DOWN
	elif dir.y < 0:
		_rover.direction = Enums.EDirection.UP

	var norm_dir: Vector2 = dir.normalized() * _rover.speed * delta
	if norm_dir.length() >= dir.length():
		# Movement completed
		_rover.tile = next_tile
		_path.pop_front()
		_move_completed()
	else:
		_rover.global_position += norm_dir


# Called when the rover completed a movement
func _move_completed() -> void:
	_remaining_range -= 1
	# Increment move counter
	_rover.on_moved()
	# Consume power module charge ?
	if _rover.move_count != 0 and (_rover.move_count % _rover.max_move_count) == 0:
		_rover.power_module.charge -= 1


# Update the selected path
func _update_path(with_range: bool):
	if with_range:
		_range = LevelSignals.compute_range(_rover.tile, _rover.range)
	_path = LevelSignals.compute_path(_rover.tile, _cursor.tile)


# Refresh the visual
func _refresh():
	if not _rover.is_moving:
		_movement_tile_map.visible = true
		_refresh_cursor_select()
	else:
		_movement_tile_map.visible = false


# Refresh the visual during cursor selection
func _refresh_cursor_select():
	if _cursor.tile == _rover.tile:
		_cursor.state = Cursor.EState.GREEN
	else:
		_cursor.state = Cursor.EState.NORMAL

	# Refresh the range indicators
	_movement_tile_map.clear()
	for tile in _range:
		_movement_tile_map.set_cell(0, tile, 0, _grey_tile)

	# Refresh the path indicators
	var path_len = len(_path)
	var path_index = 1
	var rover_range = _rover.range
	for tile in _path:
		if path_index > rover_range:
			_movement_tile_map.set_cell(0, tile, 0, _red_tile)
		elif (path_len <= rover_range and path_index == path_len) or path_index == rover_range:
			_movement_tile_map.set_cell(0, tile, 0, _white_tile)
		else:
			_movement_tile_map.set_cell(0, tile, 0, _blue_tile)

		path_index += 1
