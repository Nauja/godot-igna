# Camera for when in rocket
class_name RocketCamera
extends Camera2D


func _ready():
	LevelSignals.rocket_entered.connect(_on_rocket_entered)


# Toggle the camera
func _on_rocket_entered():
	make_current()
