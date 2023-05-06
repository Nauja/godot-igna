# Base for modules of the rover
class_name Module
extends Entity

# Possible states
enum _EState { NONE, OK, FIRE }

# Maximum integrity level
var max_integrity: int:
	get:
		return entity_sheet.max_integrity
# Initial integrity
var integrity: int:
	get:
		return integrity
	set(val):
		integrity = clamp(val, 0, val if max_integrity == 0 else max_integrity)
		RoverSignals.notify_rover_integrity_changed()
# Maximum charge level
var max_charge: int:
	get:
		return entity_sheet.max_charge
# Initial charge level
var charge: int:
	get:
		return charge
	set(val):
		charge = clamp(val, 0, val if max_charge == 0 else max_charge)
		RoverSignals.notify_rover_charge_changed()
# Animation player for the sprite
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
# Current state
var _state: _EState = _EState.NONE:
	set(val):
		if _state == val:
			return

		_state = val
		if _animation_player:
			_animation_player.play("idle" if _state == _EState.OK else "fire")


func _set_entity_sheet(val: EntitySheet) -> void:
	super(val)
	integrity = val.integrity
	charge = val.charge


func _ready():
	super()
	RoverSignals.rover_integrity_changed.connect(_on_rover_integrity_changed)
	_state = _EState.OK


func _on_rover_integrity_changed() -> void:
	_state = _EState.FIRE if integrity < max_integrity else _EState.OK


# Gain one charge of the module
func gain_charge() -> void:
	charge += 1
	if max_charge != 0:
		max_charge += 1
	RoverSignals.notify_rover_charge_changed()


# Fill to max charge
func recharge() -> void:
	if max_charge != 0:
		charge = max_charge
		RoverSignals.notify_rover_charge_changed()
