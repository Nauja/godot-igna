# Control the fire progression on the map
class_name FireController
extends Node

# Tile map for the fire
@export_subgroup("FireController")
@export_node_path("TileMap") var _fire_tile_map_path: NodePath
@onready var _fire_tile_map: TileMap = get_node(_fire_tile_map_path)
# Tiles of the tile set for the fire progression
@export var _fire_progression_tiles: Array[Vector2i]
# Current progression
var _fire_step: int


func _ready():
	LevelSignals._get_fire_progression = _get_fire_progression
	RoverSignals.rover_moved.connect(_check_rover_hit)
	RoverSignals.action_performed.connect(_on_action_performed)
	LevelSignals.level_ready.connect(_on_level_ready)


func _get_fire_progression() -> int:
	return _fire_step


func _on_level_ready():
	_fire_tile_map.clear()
	_fire_step = 0
	_refresh()


func _on_action_performed():
	var rover = RoverSignals.get_rover()
	if not rover:
		return

	if rover.range != 0 and rover.action_count % rover.range == 0:
		_progress()


func _process(delta):
	var rover = RoverSignals.get_rover()
	if not rover:
		return

	if rover.range == 0:
		_progress()


func _progress() -> void:
	var game_over_limit = LevelSignals.tile_width + LevelSignals.tile_height
	if _fire_step >= game_over_limit:
		return

	_fire_step += 1
	_refresh()
	_check_rover_hit()
	LevelSignals.notify_fire_progressed()
	if _fire_step >= game_over_limit:
		LevelSignals.game_over()


func _check_rover_hit() -> void:
	var rover = RoverSignals.get_rover()
	if not rover:
		return

	if (rover.tile.x + rover.tile.y) < _fire_step:
		rover.hit()


# Refresh the tile map
func _refresh():
	_fire_tile_map.clear()
	var tile = Vector2i(0, 0)
	var max_progression = len(_fire_progression_tiles) - 1
	for j in range(_fire_step):
		tile.y = j
		for i in range(_fire_step):
			tile.x = i - j
			_fire_tile_map.set_cell(
				0,
				tile,
				0,
				_fire_progression_tiles[clamp((_fire_step - i - 1) / 2, 0, max_progression)]
			)
