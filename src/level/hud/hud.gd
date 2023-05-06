class_name HUD
extends CanvasLayer


func _ready():
	LevelSignals.rocket_entered.connect(_on_rocket_entered)


# Hide the HUD on victory
func _on_rocket_entered() -> void:
	visible = false
