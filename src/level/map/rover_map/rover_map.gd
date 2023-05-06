class_name RoverMap
extends Map

# Instance of the engine module
@onready var engine_module: Module = %EngineModule:
	get:
		return engine_module
# Instance of the power module
@onready var power_module: Module = %PowerModule:
	get:
		return power_module


func _ready():
	super()
	RoverSignals._get_module = _get_module


func _get_module(val: Enums.EModule) -> Module:
	if val == Enums.EModule.ENGINE:
		return engine_module
	return power_module
