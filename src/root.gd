# The role of this script is to manage the screen transitions
extends Node

# Scene for the title screen
@export_subgroup("Screen")
@export var _title_scene: PackedScene
# Scene for the level screen
@export var _level_scene: PackedScene
# Option to skip the title screen
@export_subgroup("Debug")
@export var _skip_title: bool
# Map screens to scenes
@onready var _screen_scenes = {Enums.EScreen.TITLE: _title_scene, Enums.EScreen.LEVEL: _level_scene}
# Instance of current displayed screen
var _current_screen: Node


func _ready():
	# Register global signals
	GameSignals._load_screen = _load_screen
	# Display the title screen when ready
	_load_screen(Enums.EScreen.LEVEL if _skip_title else Enums.EScreen.TITLE)


# Load and display a new screen
func _load_screen(id: Enums.EScreen) -> void:
	if _current_screen:
		_current_screen.queue_free()

	# Cleanup
	LevelSignals.reset()
	RoverSignals.reset()
	PlayerSignals.reset()

	_current_screen = _screen_scenes[id].instantiate()
	add_child(_current_screen)
