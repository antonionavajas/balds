extends Node2D

func _ready():
	GLOBAL.current_scene = self
	await get_tree().process_frame
	GLOBAL.register_key_nodes()
