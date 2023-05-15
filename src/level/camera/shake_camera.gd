# Camera for when in rocket.
# This camera is randomly shaken.
class_name ShakeCamera
extends Camera

# Shake strength
@export_subgroup("Camera")
@export var _strength: int
# Delay between two shakes
@export var _delay: float
# Initial camera position
var _initial_position: Vector2
# Remaining time before next shake
var _timer: float


func _ready():
	super()
	_initial_position = position


func _physics_process(delta):
	_timer -= delta
	if _timer > 0:
		return

	_timer = _delay
	position = (
		_initial_position
		+ (
			Vector2(
				Utils.rng.randf() * _strength * 2.0 - _strength,
				Utils.rng.randf() * _strength * 2.0 - _strength
			)
			* delta
		)
	)
