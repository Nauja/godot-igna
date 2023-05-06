# Base for all 2D entities
class_name Entity
extends Node2D

# Initial configuration of the entity
@export_subgroup("Entity")
@export var _sheet: Resource
var entity_sheet: EntitySheet:
	get = _get_entity_sheet,
	set = _set_entity_sheet
# Hint when hovered with the cursor
var cursor_hint: String:
	get:
		return entity_sheet.cursor_hint if entity_sheet else ""
# Cursor priority when on the same tile as other entities
var cursor_priority: int:
	get:
		return entity_sheet.cursor_priority if entity_sheet else 0
# Tile the entity is on
var tile: Vector2i:
	get = _get_tile,
	set = _set_tile
# Current direction
var direction: Enums.EDirection = Enums.EDirection.LEFT:
	get = _get_direction,
	set = _set_direction
# Get one tile forward
var forward: Vector2i:
	get:
		return tile + Utils.forward(direction)


func _get_entity_sheet() -> EntitySheet:
	return _sheet


func _set_entity_sheet(val: EntitySheet) -> void:
	_sheet = val


func _get_tile() -> Vector2i:
	return tile


func _set_tile(val: Vector2i) -> void:
	tile = val
	position = Vector2(val * Constants.TILE_SIZE)


func _get_direction() -> Enums.EDirection:
	return direction


func _set_direction(val: Enums.EDirection) -> void:
	direction = val


func _ready():
	entity_sheet = entity_sheet
	tile = Vector2i(
		int(position.x / Constants.TILE_SIZE.x),
		int(position.y / Constants.TILE_SIZE.y),
	)
	# React to when the rover moves
	RoverSignals.rover_moved.connect(_on_rover_moved)


func _on_rover_moved():
	pass


func is_same_tile(other: Entity) -> bool:
	return tile == other.tile


func is_facing(other: Entity) -> bool:
	return forward == other.tile
