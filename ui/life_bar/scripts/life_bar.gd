extends ProgressBar
class_name LifeBar

@onready var label : Label = $Label

func set_max_life(max_life : int) -> void:
	max_value = max_life
	
func set_life(actual_life: int) -> void:
	value = float(actual_life)
	label.text = str(actual_life)

func set_bar_visibility():
	if max_value == value:
		visible = false
		label.visible = false
	else: 
		visible = true
		label.visible = true
