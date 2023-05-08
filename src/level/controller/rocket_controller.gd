# Controller for when in the rocket.
# The player can't move in the rocket, and there is an automatic transition
# to the title screen after a given delay
class_name RocketController
extends Controller

# Delay before going back to the title screen
@export_subgroup("Controller")
@export var _back_to_title_delay: int
# Time before going back to the title screen
var _back_to_title_timer: float


func _ready():
	# Map this controller is active on
	_map = Enums.EMap.ROCKET
	super()
	_back_to_title_timer = _back_to_title_delay


func _process(delta):
	super(delta)
	_back_to_title_timer -= delta
	if _back_to_title_timer <= 0:
		GameSignals.load_screen(Enums.EScreen.TITLE)
