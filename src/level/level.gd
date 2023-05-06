extends Node

enum _EView { MAP, ROVER, ROCKET }

# Instance of the map
@export_subgroup("Level")
@export_node_path("Map") var _map_path: NodePath
@onready var _map: Map = get_node(_map_path)
# Instance of the rover map
@export_node_path("RoverMap") var _rover_map_path: NodePath
@onready var _rover_map: RoverMap = get_node(_rover_map_path)
# Instance of the rocket map
@export_node_path("Map") var _rocket_map_path: NodePath
@onready var _rocket_map: Map = get_node(_rocket_map_path)
# Scene to spawn bombs
@export var _bomb_scene: PackedScene
# Instance of the cursor
@onready var _cursor: Cursor = %Cursor
# Instance of the player
@onready var _player: Player = %Player
# Where the player must start in the rover
@onready var _player_start_rover: Node2D = _rover_map.find_child("PlayerStart")
# Where the player must start in the roket
@onready var _player_start_rocket: Node2D = _rocket_map.find_child("PlayerStart")
# Instance of the rover
@onready var _rover: Rover = %Rover
# Root node for the map view
@onready var _map_view_root: Node = %MapViewRoot
# Root node for the rover view
@onready var _rover_view_root: Node = %RoverViewRoot
# Root node for the rocket view
@onready var _rocket_view_root: Node = %RocketViewRoot
# Current view
var _view: _EView = _EView.MAP
# Entities on the curent map
var _entities: Array[Entity]:
	get:
		match _view:
			_EView.MAP:
				return _map.entities
			_EView.ROVER:
				return _rover_map.entities
			_EView.ROCKET:
				return _rocket_map.entities
		return []
# Bombs on the map
var _bombs: Array[Entity] = []


func _ready():
	LevelSignals._tile_width = _get_tile_width
	LevelSignals._tile_height = _get_tile_height
	LevelSignals._width = _get_width
	LevelSignals._height = _get_height
	LevelSignals._get_cursor = _get_cursor
	PlayerSignals._get_player = _get_player
	RoverSignals._get_rover = _get_rover
	RoverSignals._enter_rover = _enter_rover
	RoverSignals._exit_rover = _exit_rover
	LevelSignals._compute_path = _compute_path
	LevelSignals._compute_range = _compute_range
	LevelSignals._is_walkable = _is_walkable
	LevelSignals._get_entity = _get_entity
	RoverSignals.rover_moved.connect(_on_rover_moved)
	LevelSignals._game_over = _game_over
	LevelSignals._enter_rocket = _enter_rocket
	RoverSignals._drop_bomb = _drop_bomb
	RoverSignals._is_bomb = _is_bomb
	RoverSignals._remove_bomb = _remove_bomb
	# Place rover on start tile
	_rover.tile = Utils.world_to_tile(find_child("RoverStart").position)
	# Start level
	LevelSignals.notify_level_ready()
	_exit_rover()


func _get_tile_width() -> int:
	return _map.tile_width


func _get_tile_height() -> int:
	return _map.tile_height


func _get_width() -> int:
	return _map.width


func _get_height() -> int:
	return _map.height


func _get_cursor() -> Cursor:
	return _cursor


func _get_player() -> Player:
	return _player


func _get_rover() -> Rover:
	return _rover


func _enter_rover() -> void:
	Input.action_release("action")
	_player.tile = Utils.world_to_tile(_player_start_rover.position)
	_player.direction = Enums.EDirection.LEFT
	_map_view_root.visible = false
	_rover_view_root.visible = true
	_rocket_view_root.visible = false
	_view = _EView.ROVER
	_rover.is_paused = true
	RoverSignals.notify_rover_entered()


func _exit_rover() -> void:
	Input.action_release("action")
	_map_view_root.visible = true
	_rover_view_root.visible = false
	_rocket_view_root.visible = false
	_view = _EView.MAP
	_rover.is_paused = false
	RoverSignals.notify_rover_exited()


func _enter_rocket() -> void:
	Input.action_release("action")
	_rover_view_root.remove_child(_player)
	_rocket_view_root.add_child(_player)
	_player.tile = Utils.world_to_tile(_player_start_rocket.position)
	_player.direction = Enums.EDirection.DOWN
	_map_view_root.visible = false
	_rover_view_root.visible = false
	_rocket_view_root.visible = true
	_view = _EView.ROCKET
	LevelSignals.notify_rocket_entered()


class _PriorityTile:
	var tile: Vector2i
	var priority: int


func _compute_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	if not _is_walkable(to) or from == to:
		return []

	var path: Array[Vector2i] = []
	var searchrange = 32

	var frontier: Array[_PriorityTile] = []
	_insert(frontier, from, 0)
	var came_from = {}
	var cost_so_far = {from: 0}

	var next = Vector2i(0, 0)

	while len(frontier) > 0:
		var current = frontier.pop_back()

		# goal is reached
		if current.tile == to:
			break

		for i in range(-1, 2):
			for j in range(-1, 2):
				if (i == 0 or j == 0) and i != j:
					next.x = current.tile.x + i
					next.y = current.tile.y + j
					if not _is_walkable(next):
						continue

					var new_cost = cost_so_far[current.tile] + 1  # add extra costs here
					var old_cost = cost_so_far.get(next)
					if old_cost == null or new_cost < old_cost:
						cost_so_far[next] = new_cost
						var priority = new_cost + Utils.distance(to, next)
						came_from[next] = current
						_insert(frontier, next, priority)

	path.push_back(to)
	var current = came_from.get(to)
	if current:
		while current.tile != from:
			path.push_back(current.tile)
			current = came_from[current.tile]

	path.reverse()
	return path


func _compute_range(center: Vector2i, distance: int) -> Array[Vector2i]:
	var queue: Array[Vector2i] = [center]
	var cost_so_far = {center: 0}
	var reachbox = Rect2i(center.x - distance, center.y - distance, distance * 2, distance * 2)
	var next = Vector2i(0, 0)

	while len(queue) > 0 and len(queue) < 512:
		var current = queue.pop_back()
		var new_cost: int = cost_so_far[current] + 1

		for i in range(-1, 2):
			for j in range(-1, 2):
				if i == 0 or j == 0 and i != j:
					next.x = current.x + i
					next.y = current.y + j
					if (
						next.x < reachbox.position.x
						or next.y < reachbox.position.y
						or next.x > reachbox.end.x
						or next.y > reachbox.end.y
					):
						continue
					if not _is_walkable(next):
						continue

					var old_cost = cost_so_far.get(next)
					if old_cost == null or new_cost < old_cost:
						cost_so_far[next] = new_cost
						queue.append(next)

	var result: Array[Vector2i] = []
	for tile in cost_so_far:
		if cost_so_far[tile] <= distance:
			result.append(tile)

	return result


func _insert(l: Array[_PriorityTile], tile: Vector2i, priority: int) -> void:
	var p = _PriorityTile.new()
	p.tile = tile
	p.priority = priority

	if len(l) > 0:
		var i = len(l)
		while i > 0:
			if l[i - 1].priority >= priority:
				l.insert(i, p)
				return
			i -= 1

		l.push_front(p)
	else:
		l.push_back(p)


# Check if a tile is walkable
func _is_walkable(tile: Vector2i) -> bool:
	return (_map if _view == _EView.MAP else _rover_map).is_walkable(tile)


func _get_entity(tile: Vector2i) -> Entity:
	var found_entity: Entity = null
	var found_priotity: int = -1
	for entity in _entities:
		if (
			is_instance_valid(entity)
			and entity.tile == tile
			and entity.cursor_priority > found_priotity
		):
			found_entity = entity
			found_priotity = entity.cursor_priority

	return found_entity


# Detect collision with spikes here
func _on_rover_moved() -> void:
	if _map.is_spikes(_rover.tile):
		_rover.hit()


func _game_over() -> void:
	pass


func _victory() -> void:
	pass


func _drop_bomb() -> void:
	if not _is_bomb(_rover.tile):
		var bomb = _bomb_scene.instantiate()
		_map_view_root.add_child(bomb)
		bomb.tile = _rover.tile
		_bombs.append(bomb)


func _is_bomb(tile: Vector2i) -> bool:
	for bomb in _bombs:
		if bomb.tile == tile:
			return true

	return false


func _remove_bomb(tile: Vector2i) -> void:
	for i in range(len(_bombs) - 1, -1, -1):
		if _bombs[i].tile == tile:
			_bombs[i].queue_free()
			_bombs.remove_at(i)
