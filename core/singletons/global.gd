extends Node

var current_scene : Node = null
var player : PlayerController = null

func set_scene(scene_path: String):
	var new_scene = load(scene_path).instantiate()

	if current_scene:
		current_scene.queue_free()

	get_tree().root.add_child(new_scene)
	current_scene = new_scene

	await get_tree().process_frame
	register_key_nodes()

func reload_current_scene():
	if not current_scene:
		push_error("No scene to reload!")
		return

	var scene_path = current_scene.scene_file_path
	set_scene(scene_path)

func register_key_nodes():
	if current_scene.has_node("Player"):
		player = current_scene.get_node("Player")
	else:
		player = null
