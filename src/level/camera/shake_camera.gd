# Camera for when in rocket.
# This camera is randomly shaken.
class_name ShakeCamera
extends Camera

# Shake strength
@export_subgroup("Camera")
@export var _strength: int
# Initial camera position
var _initial_position: Vector2


func _ready():
	super()
	_initial_position = position


func _physics_process(delta):
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
