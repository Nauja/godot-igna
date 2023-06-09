# Controller for when in the rover.
# The crew is controller as in an old-school RPG game, and the player can
# press the action key to interact with objects or crew members
class_name RoverController
extends Controller

# Instance of the player
@export_subgroup("Controller")
@export_node_path("Player") var _player_path: NodePath
@onready var _player: Player = get_node(_player_path)
# How fast input are repeated when pressed down
@export var _input_repeat: float
# Time to wait before next input
var _input_delay: float


func _ready():
	# Map this controller is active on
	_map = Enums.EMap.ROVER
	_allow_diagonals = false
	super()


# Try to interact with entities in the rover
func _process(delta):
	super(delta)
	if Input.is_action_just_pressed("action"):
		PlayerSignals.notify_player_interact()


# Move the player by one tile
func _physics_process(delta):
	if LevelSignals.is_dialogue_open():
		return

	var dir = input_direction

	if _input_delay >= 0:
		_input_delay -= delta

	if (dir.x != 0 or dir.y != 0) and _input_delay <= 0:
		_input_delay = _input_repeat
		var desired_tile = _player.tile + dir
		if _is_walkable(desired_tile):
			_player.tile += dir
		_player.direction = Utils.facing_direction(dir)
		PlayerSignals.notify_player_moved()


# Return if a tile of the map is walkable
func _is_walkable(tile: Vector2i) -> bool:
	if not LevelSignals.is_walkable(tile):
		return false

	var entities = LevelSignals.entities
	for entity in entities:
		if entity.visible and entity.tile == tile:
			return false

	return true
