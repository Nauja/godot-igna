# Camera for when on the world map.
# This camera follows the cursor as in a tactical game
class_name FollowCursorCamera
extends Camera


# Center camera on cursor when level starts
func _on_level_ready():
	var cursor = LevelSignals.cursor
	if not cursor:
		return

	var camera_pos = cursor.global_position
	var hscreen_size = get_viewport().get_visible_rect().size / 2
	global_position = Vector2(max(camera_pos.x, hscreen_size.x), max(camera_pos.y, hscreen_size.y))


# Follow the cursor
func _process(delta):
	var cursor = LevelSignals.cursor
	if not cursor:
		return

	var tile_width = LevelSignals.tile_width
	var tile_height = LevelSignals.tile_height
	var screen_size = get_viewport().get_visible_rect().size
	var hscreen_size = screen_size / 2
	var cursor_pos = cursor.global_position
	var camera_pos = global_position - hscreen_size

	if cursor_pos.x < camera_pos.x + 20:
		camera_pos.x = max(camera_pos.x - 2, 0)
	if cursor_pos.x > camera_pos.x + screen_size.x - 20 - 8:
		camera_pos.x = min(camera_pos.x + 2, tile_width * 8 - screen_size.x - 8)

	if cursor_pos.y < camera_pos.y + 20:
		camera_pos.y = max(camera_pos.y - 2, 0)
	if cursor_pos.y > camera_pos.y + screen_size.y - 28:
		camera_pos.y = min(camera_pos.y + 2, tile_height * 8 - screen_size.y - 8)

	global_position = lerp(global_position, camera_pos + hscreen_size, 25 * delta)
