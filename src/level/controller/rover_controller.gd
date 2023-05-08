# Controller for when in the rover.
# The crew is controller as in an old-school RPG game
class_name RoverController
extends Controller

# Instance of the cursor
@export_subgroup("Controller")
# Instance of the player
@export_node_path("Player") var _player_path: NodePath
@onready var _player: Player = get_node(_player_path)
# How fast input are repeated when pressed down
@export var _input_repeat: float
# Time to wait before next input
var _input_delay: float


func _ready():
	_map = Enums.EMap.ROVER
	_allow_diagonals = false
	super()


func _process(delta):
	super(delta)
	if Input.is_action_just_pressed("action"):
		PlayerSignals.notify_player_interact()


func _physics_process(delta):
	if LevelSignals.is_dialogue_open():
		return

	var dir = input_direction

	if _input_delay >= 0:
		_input_delay -= delta

	if (dir.x != 0 or dir.y != 0) and _input_delay <= 0:
		_input_delay = _input_repeat
		var desired_tile = _player.tile + dir
		if LevelSignals.is_walkable(desired_tile):
			_player.tile += dir
		_player.direction = Utils.facing_direction(dir)
		PlayerSignals.notify_player_moved()
