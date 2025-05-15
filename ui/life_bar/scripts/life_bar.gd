@tool
class_name LifeBar
extends ProgressBar

@export var life_system : LifeSystem = null:
	set(value):
		life_system = value
		notify_property_list_changed()
	get:
		return life_system

@onready var label : Label = $Label

func ready() -> void:
	pass
	
func _process(delta: float) -> void:
	update_life()

func update_life() -> void:
	max_value = life_system.max_life
	value = float(life_system.life)
	label.text = str(life_system.life)
	set_bar_visibility()

func set_bar_visibility():
	if life_system.life == life_system.max_life:
		visible = false
		label.visible = false
	else: 
		visible = true
		label.visible = true

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if life_system == null:
		warnings.append("LifeSystem is not assigned! This LifeBar will not function properly.")
	return warnings
