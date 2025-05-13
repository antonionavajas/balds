extends Node

var current_scene : Node
var player : Player

func _ready() -> void:
	current_scene = get_tree().current_scene
	if current_scene :
		player = current_scene.get_node('Player')
