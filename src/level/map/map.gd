# Representation of the map.
# A map is composed of multiple tile maps used to design the terrain. When the
# level starts, it builds a cache of all tiles with collisions or spikes, to
# speed up computing the accessibility range, and the path later
class_name Map
extends Node

# What map it is
@export_subgroup("Map")
@export var _map: Enums.EMap
# Tile maps composing the map.
# We could have one tile map for the terrain, and a second one for the objects
@export var _tile_map_paths: Array[NodePath]
var _tile_maps: Array[TileMap]
# Width of the map in tiles
var tile_width: int:
	get:
		return tile_width
# Height of the map in tiles
var tile_height: int:
	get:
		return tile_height
# Width of the map in pixels
var width: int:
	get:
		return width
# Height of the map in pixels
var height: int:
	get:
		return height
# Entities on the map
var entities: Array[Entity] = []:
	get:
		return entities
# Cache tiles with collisions
var _collision_map: Array[bool] = []
# Cache tiles with spikes
var _spikes_map: Array[bool] = []


func _ready():
	# Compute the size of the map
	_compute_size()
	# Cache collisions and spikes
	_build_cache()
	# Gather entities
	entities = []
	for node in get_tree().get_nodes_in_group("entity"):
		if is_ancestor_of(node):
			add_entity(node)


# Compute the total size of the map by combining all tile maps
func _compute_size() -> void:
	tile_width = 0
	tile_height = 0
	_tile_maps = []
	for path in _tile_map_paths:
		var tile_map: TileMap = get_node(path)
		var rect = tile_map.get_used_rect()
		tile_width = max(tile_width, rect.size.x)
		tile_height = max(tile_height, rect.size.y)
		_tile_maps.append(tile_map)
	width = tile_width * Constants.TILE_SIZE.x
	height = tile_height * Constants.TILE_SIZE.x


# Combine all tile maps into a single collision map, and spikes map, to speed
# up the A* algorithm
func _build_cache() -> void:
	_collision_map = []
	_spikes_map = []
	var tile = Vector2i(0, 0)
	var index = 0
	for j in range(tile_height):
		tile.y = j
		for i in range(tile_width):
			tile.x = i
			_collision_map.append(_tile_has_property(tile, "collision"))
			_spikes_map.append(_tile_has_property(tile, "spikes"))
			index += 1


# Check on all tile maps if a tile has a specific property
func _tile_has_property(tile: Vector2i, name: String) -> bool:
	for tile_map in _tile_maps:
		var tile_data = tile_map.get_cell_tile_data(0, tile)
		if tile_data and tile_data.get_custom_data(name):
			return true

	return false


# Convert a tile to index to access the cache
func _tile_to_index(tile: Vector2i) -> int:
	return tile.x + tile.y * tile_width


# Return if a tile is walkable
func is_walkable(tile: Vector2i) -> bool:
	var index = _tile_to_index(tile)
	return not _collision_map[index] if index >= 0 and index < len(_collision_map) else false


# Return if a tile is spikes
func is_spikes(tile: Vector2i) -> bool:
	var index = _tile_to_index(tile)
	return _spikes_map[index] if index >= 0 and index < len(_spikes_map) else false


# Remove an entity from the map
func remove_entity(entity: Entity) -> void:
	entities.remove_at(entities.find(entities))
	if is_ancestor_of(entity):
		entity.get_parent().remove_child(entity)


# Add an entity to the map
func add_entity(entity: Entity) -> void:
	if entities.find(entity) < 0:
		entities.push_back(entity)
	entity.get_parent().remove_child(entity)
	add_child(entity)
	entity.map = _map
