extends Button

func _ready_ready() -> void:
	self.connect('pressed', restart)
	
func restart(): 
	GLOBAL.reload_current_scene()
