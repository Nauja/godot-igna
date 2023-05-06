class_name Player
extends Entity

# Sheet storing the initial player configuration
var player_sheet: PlayerSheet:
	get = _get_player_sheet,
	set = _set_player_sheet
# Sprite of the player
@onready var _sprite: Sprite2D = %Sprite2D


func _get_player_sheet() -> PlayerSheet:
	return entity_sheet


# Initialize the player with a new sheet
func _set_player_sheet(val: PlayerSheet) -> void:
	entity_sheet = val


func _set_direction(val: Enums.EDirection) -> void:
	if direction == val:
		return

	super(val)
	if direction == Enums.EDirection.LEFT or direction == Enums.EDirection.RIGHT:
		_sprite.texture = player_sheet.left_texture
	elif direction == Enums.EDirection.UP:
		_sprite.texture = player_sheet.up_texture
	else:
		_sprite.texture = player_sheet.down_texture

	_sprite.flip_h = direction == Enums.EDirection.RIGHT
