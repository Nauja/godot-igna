class_name Dialogue
extends Control

# Label for the dialogue
@onready var _label: Label = %Label


func _ready():
	LevelSignals._open_dialogue = _open_dialogue
	LevelSignals._close_dialogue = _close_dialogue
	LevelSignals._set_dialogue = _set_dialogue
	LevelSignals._is_dialogue_open = _is_dialogue_open
	_close_dialogue()


func _open_dialogue() -> void:
	visible = true


func _close_dialogue() -> void:
	visible = false


func _set_dialogue(speaker: Entity, val: String) -> void:
	_label.text = ((speaker.cursor_hint + ": ") if speaker else "") + val


func _is_dialogue_open() -> bool:
	return visible
