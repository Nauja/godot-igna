class_name Crew
extends Entity


func _ready():
	super()
	# Hide the crew member by default
	visible = false
	# Wait for being rescued
	LevelSignals.human_rescued.connect(_on_human_rescued)


func _on_human_rescued(sheet: FellowHumanSheet) -> void:
	if sheet == entity_sheet.fellow_human_sheet:
		visible = true
