class_name Cursor
extends Entity

# Possible states of the cursor
enum EState { NORMAL, GREEN }

# Texture for the normal cursor
@export_subgroup("Entity")
@export var _normal_texture: Texture2D
# Texture for the green cursor
@export var _green_texture: Texture2D
# Current state of the cursor
@export var state: EState:
	get = _get_state,
	set = _set_state
@onready var _sprite: Sprite2D = %Sprite2D


func _get_state() -> EState:
	return state


# Set the new state and change the texture
func _set_state(val: EState) -> void:
	if state == val:
		return

	state = val
	_refresh()


func _ready():
	super()
	_refresh()


# Refresh the visual
func _refresh() -> void:
	if _sprite:
		if state == EState.NORMAL:
			_sprite.texture = _normal_texture
		elif state == EState.GREEN:
			_sprite.texture = _green_texture
