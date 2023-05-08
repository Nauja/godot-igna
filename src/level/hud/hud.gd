class_name HUD
extends CanvasLayer


func _ready():
	LevelSignals.map_changed.connect(_on_map_changed)


# Hide the HUD on victory
func _on_map_changed() -> void:
	visible = LevelSignals.map != Enums.EMap.ROCKET
