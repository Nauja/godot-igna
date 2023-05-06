class_name Worm
extends Entity

# Possible states
enum _EState { NONE, UNDEGROUND, MOVE }

# Instance of the animation player
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
# Current state
var _state: _EState = _EState.NONE:
	set(val):
		if _state == val:
			return

		_state = val
		if _animation_player:
			_animation_player.play("idle" if val == _EState.UNDEGROUND else "move")


func _ready():
	super()
	RoverSignals.action_performed.connect(_on_action_performed)
	_state = _EState.UNDEGROUND


func _on_action_performed() -> void:
	var rover = RoverSignals.get_rover()
	if not rover:
		return

	# If the rover moved on the worm
	if _state == _EState.MOVE and self.tile == rover.tile:
		rover.hit()
		_state = _EState.UNDEGROUND
		return

	var range = int(floor(rover.range / 4.0))
	if range != 0 and rover.action_count % range == 0:
		_action()


func _action() -> void:
	var rover = RoverSignals.get_rover()
	if not rover:
		return

	if _state == _EState.UNDEGROUND:
		if Utils.distance(self.tile, rover.tile) < 32:
			_state = _EState.MOVE
	elif _state == _EState.MOVE:
		var path = LevelSignals.compute_path(self.tile, rover.tile)
		if len(path) == 0:
			return

		self.tile = path[0]

		# If the worm moved on the rover
		if self.tile == rover.tile:
			rover.hit()
			_state = _EState.UNDEGROUND
		elif Utils.distance(self.tile, rover.tile) > 64:
			_state = _EState.UNDEGROUND
