# Base for cameras.
# We basically have two cameras:
# - FollowCursorCamera: follows the cursor on the world map
# - FixedCamera: fixed camera when in the rover or in the rocket
class_name Camera
extends Camera2D

# Map the camera is active on.
# The camera does _process and _physics_process only when this is the
# current map
@export_subgroup("Camera")
@export var _map: Enums.EMap


func _ready():
	LevelSignals.level_ready.connect(_on_level_ready)
	LevelSignals.map_changed.connect(_on_map_changed)


func _on_level_ready():
	pass


# Make it the current camera when on the desired map
func _on_map_changed():
	var current_map = LevelSignals.get_map()
	set_process(_map == current_map)
	set_physics_process(_map == current_map)
	if _map == current_map:
		make_current()
