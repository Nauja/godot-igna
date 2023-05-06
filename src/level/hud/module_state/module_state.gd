# Display the state of a single module of the rover
class_name ModuleState
extends Node

# Module to display
@export_subgroup("ModuleState")
@export var module: Enums.EModule:
	get:
		return module
	set(val):
		module = val
		if _integrity_bar:
			_integrity_bar.module = val
		_refresh()
# Animation player for the sprite
@export var _animation_player_scene: PackedScene
# Integrity bar
@onready var _integrity_bar: IntegrityBar = %IntegrityBar
# Label to display the number of charges of the module
@onready var _charge_label: Label = %ChargeLabel
# Spawned animation player
var _animation_player: AnimationPlayer
# Number of charges
var value: int:
	get:
		var m = RoverSignals.get_module(module)
		return m.charge if m else 0


func _ready():
	LevelSignals.level_ready.connect(_refresh)
	RoverSignals.rover_charge_changed.connect(_refresh)
	# Spawn the animation player
	_animation_player = _animation_player_scene.instantiate()
	_animation_player.play("idle")
	add_child(_animation_player)


func _refresh():
	# Correctly configure the integrity bar
	if _integrity_bar:
		_integrity_bar.module = module

	# Update label
	if _charge_label:
		_charge_label.text = str(value)
