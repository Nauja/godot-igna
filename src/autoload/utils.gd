extends Node

var rng = RandomNumberGenerator.new()


func distance(from: Vector2i, to: Vector2i) -> int:
	return abs(from.x - to.x) + abs(from.y - to.y)


func tile_to_world(tile: Vector2i) -> Vector2:
	return Vector2(tile.x * Constants.TILE_SIZE.x, tile.y * Constants.TILE_SIZE.y)


func world_to_tile(pos: Vector2) -> Vector2i:
	return Vector2i(int(pos.x / Constants.TILE_SIZE.x), int(pos.y / Constants.TILE_SIZE.y))


func facing_direction(dir: Vector2i) -> Enums.EDirection:
	if dir.x < 0:
		return Enums.EDirection.LEFT
	if dir.x > 0:
		return Enums.EDirection.RIGHT
	if dir.y < 0:
		return Enums.EDirection.UP
	return Enums.EDirection.DOWN


func forward(dir: Enums.EDirection) -> Vector2i:
	match dir:
		Enums.EDirection.LEFT:
			return Vector2i(-1, 0)
		Enums.EDirection.RIGHT:
			return Vector2i(1, 0)
		Enums.EDirection.UP:
			return Vector2i(0, -1)
	return Vector2i(0, 1)
