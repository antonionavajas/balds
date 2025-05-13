extends Button

func _process(delta: float) -> void:
	self.connect('pressed', restart)
	
func restart(): 
	get_tree().reload_current_scene()
