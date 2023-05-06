# Camera for when in rover
class_name RoverCamera
extends Camera2D


func _ready():
	RoverSignals.rover_entered.connect(_on_rover_entered)


# Toggle the camera
func _on_rover_entered():
	make_current()
