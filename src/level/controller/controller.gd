class_name Controller
extends Node2D

enum _EMap { MAP, ROVER, ROCKET }

# The map for the controller to be active
var _map: _EMap
# Allow moving in all 8 directions
var _allow_diagonals: bool
# Pressed directions
var input_direction: Vector2i = Vector2i(0, 0):
	get:
		return input_direction


func _ready():
	LevelSignals.level_ready.connect(_on_level_ready)
	RoverSignals.rover_entered.connect(_on_rover_entered)
	RoverSignals.rover_exited.connect(_on_rover_exited)
	LevelSignals.rocket_entered.connect(_on_rocket_entered)


func _on_level_ready():
	pass


# Prevent processing input when controller should be inactive
func _on_rover_entered():
	set_process(_map == _EMap.ROVER)
	set_physics_process(_map == _EMap.ROVER)


func _on_rover_exited():
	set_process(_map == _EMap.MAP)
	set_physics_process(_map == _EMap.MAP)


func _on_rocket_entered():
	set_process(_map == _EMap.ROCKET)
	set_physics_process(_map == _EMap.ROCKET)


# Return the current pressed direction
func _process(delta) -> void:
	if not _allow_diagonals:
		_process_input_no_diagonals()
	else:
		_process_input_diagonals()


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
