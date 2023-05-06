class_name Worm
extends Entity

# Possible states
enum _EState { NONE, IDLE, MOVE, KILLED }

# Instance of the animation player
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
# Current state
var _state: _EState = _EState.NONE:
	set(val):
		if _state == val:
			return

		_state = val
		if _animation_player:
			_animation_player.play(
				{_EState.IDLE: "idle", _EState.MOVE: "move", _EState.KILLED: "killed"}[val]
			)


func _ready():
	super()
	RoverSignals.action_performed.connect(_on_action_performed)
	RoverSignals.bomb_dropped.connect(_check_bomb_killed)
	_state = _EState.IDLE


func _on_action_performed() -> void:
	var rover = RoverSignals.get_rover()
	if not rover:
		return

	# If the rover moved on the worm
	if _state == _EState.MOVE and self.tile == rover.tile:
		rover.hit()
		_state = _EState.IDLE
		return

	var range = int(floor(rover.range / 4.0))
	if range != 0 and rover.action_count % range == 0:
		_action()


func _action() -> void:
	var rover = RoverSignals.get_rover()
	if not rover:
		return

	if _state == _EState.IDLE:
		if Utils.distance(self.tile, rover.tile) < 32:
			_state = _EState.MOVE
			# Worm can appear on a bomb
			_check_bomb_killed()
	elif _state == _EState.MOVE:
		var path = LevelSignals.compute_path(self.tile, rover.tile)
		if len(path) == 0:
			return

		self.tile = path[0]

		# If the worm moved on a bomb
		if _check_bomb_killed():
			return
		# If the worm moved on the rover
		elif self.tile == rover.tile:
			rover.hit()
			_state = _EState.IDLE
		elif Utils.distance(self.tile, rover.tile) > 64:
			_state = _EState.IDLE


# Check if worm is killed by a bomb
func _check_bomb_killed() -> bool:
	if _state == _EState.MOVE and RoverSignals.is_bomb(self.tile):
		_state = _EState.KILLED
		RoverSignals.remove_bomb(self.tile)
		return true

	return false
