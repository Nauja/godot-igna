# Base for controllers.
# We basically have two controllers:
# - WorldController: handles inputs when outside of rover
# - RoverController: handles inputs when inside of rover
class_name Controller
extends Node2D

# Map the controller is active on.
# The controller does _process and _physics_process only when this is the
# current map
var _map: Enums.EMap
# Allow moving in all 8 directions
var _allow_diagonals: bool
# Pressed directions
var input_direction: Vector2i = Vector2i(0, 0):
	get:
		return input_direction


func _ready():
	LevelSignals.level_ready.connect(_on_level_ready)
	LevelSignals.map_changed.connect(_on_map_changed)


func _on_level_ready():
	pass


# Prevent processing inputs when not on the desired map
func _on_map_changed():
	var current_map = LevelSignals.map
	set_process(_map == current_map)
	set_physics_process(_map == current_map)


# Compute the pressed direction
func _process(delta) -> void:
	if not _allow_diagonals:
		_process_input_no_diagonals()
	else:
		_process_input_diagonals()


# Compute the pressed direction, not allowing diagonals (player inside of rover)
func _process_input_no_diagonals() -> void:
	if (
		Input.is_action_just_pressed("move_left")
		or (Input.is_action_pressed("move_left") and input_direction.y == 0)
	):
		input_direction = Vector2i(-1, 0)
	elif Input.is_action_just_released("move_left") and input_direction.x == -1:
		input_direction.x = 0
	if (
		Input.is_action_just_pressed("move_right")
		or (Input.is_action_pressed("move_right") and input_direction.y == 0)
	):
		input_direction = Vector2i(1, 0)
	elif Input.is_action_just_released("move_right") and input_direction.x == 1:
		input_direction.x = 0

	if (
		Input.is_action_just_pressed("move_up")
		or (Input.is_action_pressed("move_up") and input_direction.x == 0)
	):
		input_direction = Vector2i(0, -1)
	elif Input.is_action_just_released("move_up") and input_direction.y == -1:
		input_direction.y = 0
	if (
		Input.is_action_just_pressed("move_down")
		or (Input.is_action_pressed("move_down") and input_direction.x == 0)
	):
		input_direction = Vector2i(0, 1)
	elif Input.is_action_just_released("move_down") and input_direction.y == 1:
		input_direction.y = 0


# Compute the pressed direction, allowing diagonals (cursor outside of rover)
func _process_input_diagonals() -> void:
	if Input.is_action_pressed("move_left"):
		input_direction.x = -1
	elif Input.is_action_pressed("move_right"):
		input_direction.x = 1
	else:
		input_direction.x = 0
	if Input.is_action_pressed("move_up"):
		input_direction.y = -1
	elif Input.is_action_pressed("move_down"):
		input_direction.y = 1
	else:
		input_direction.y = 0
