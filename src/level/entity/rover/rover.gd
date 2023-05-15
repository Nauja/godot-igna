# Rover moving on the world map
class_name Rover
extends Entity

# Sheet storing the initial rover configuration
var rover_sheet: RoverSheet:
	get = _get_rover_sheet,
	set = _set_rover_sheet
# Sprite of the rover
@onready var _sprite: Sprite2D = %Sprite2D
# Sprite when charging
@onready var _charging_sprite: Sprite2D = %ChargingSprite
# Get the power module
var power_module: Module:
	get:
		return RoverSignals.get_module(Enums.EModule.POWER)
# Get the engine module
var engine_module: Module:
	get:
		return RoverSignals.get_module(Enums.EModule.ENGINE)
# Number of bombs
var bombs: int
# Movement speed
var speed: float
# Maximum move count before the power module loses one charge
var max_move_count: int
# Movement range
var range: int:
	get = _get_range
var action_count: int:
	get:
		return action_count
# Current move count
var move_count: int:
	get:
		return move_count
# If the rover is moving along the path
var is_moving: bool
# If the movement is paused
var is_paused: bool
# If the rover is on a power station
var is_charging: bool:
	get:
		return is_charging
# Delay before next frame of the charging animation
var _charging_frame_delay: float


func _get_rover_sheet() -> RoverSheet:
	return entity_sheet


# Initialize the rover with a new sheet
func _set_rover_sheet(val: RoverSheet) -> void:
	entity_sheet = val


func _set_entity_sheet(val: EntitySheet) -> void:
	super(val)
	bombs = val.bombs
	speed = val.speed
	max_move_count = val.max_move_count


func _set_direction(val: Enums.EDirection) -> void:
	if direction == val:
		return

	super(val)
	if direction == Enums.EDirection.LEFT or direction == Enums.EDirection.RIGHT:
		_sprite.texture = rover_sheet.left_texture
	else:
		_sprite.texture = rover_sheet.up_texture

	_sprite.flip_h = direction == Enums.EDirection.RIGHT
	_sprite.flip_v = direction == Enums.EDirection.DOWN


func _get_range() -> int:
	var pm = power_module
	var em = engine_module
	if not pm or not em or pm.charge == 0:
		return 0

	return int(ceil((em.integrity / 3.0) * em.charge * 4.0))


func _ready():
	super()
	direction = Enums.EDirection.DOWN


func _physics_process(delta):
	if is_charging:
		_charging_frame_delay -= delta
		if _charging_frame_delay > 0:
			return

		# Make the animation 30 fps as in the original game
		_charging_frame_delay = 1.0 / 30.0
		_charging_sprite.visible = true
		_charging_sprite.region_rect = Rect2(
			0, 0, ceil(Utils.rng.randf() * 8.0), ceil(Utils.rng.randf() * 8.0)
		)
	elif _charging_sprite.visible:
		_charging_sprite.visible = false


# Lose one integrity of the power module
func lose_power_module_integrity() -> void:
	var pm = power_module
	if pm:
		pm.integrity = max(0, pm.integrity - 1)
		RoverSignals.notify_rover_integrity_changed()


# Set if the rover is charging on a power station
func set_charging(val: bool) -> void:
	is_charging = val

	if val:
		stop()
		var pm = power_module
		if pm:
			pm.recharge()
		RoverSignals.notify_rover_charge_changed()
		RoverSignals.notify_rover_charging()


# The rover moved by one tile
func on_moved() -> void:
	action_count += 1
	move_count += 1
	print("rover moved: action_count=", action_count, ", move_count=", move_count)
	RoverSignals.notify_rover_moved()
	RoverSignals.notify_action_performed()


# Stop the vehicle
func stop() -> void:
	print("rover stopped")
	move_count = 0
	is_moving = false


# Hit by an obstacle
func hit() -> void:
	print("rover hit")
	stop()

	var em = engine_module
	var pm = power_module
	if pm and em:
		if Utils.rng.randf() > 0.5:
			engine_module.integrity -= 1
		else:
			power_module.integrity -= 1

		power_module.charge = min(power_module.integrity, power_module.charge)

	RoverSignals.notify_rover_hit()
