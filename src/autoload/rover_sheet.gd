# Configuration of the rover
class_name RoverSheet
extends EntitySheet

# Texture for when the rover is going up
@export_subgroup("EntitySheet")
@export var up_texture: Texture2D
# Texture for when the rover is going left
@export var left_texture: Texture2D
# Number of bombs
@export var bombs: int = 3
# Speed on map
@export var speed: float = 1
# Maximum move count before the power module loses one charge
@export var max_move_count: int = 32
