@tool
class_name SkeletonHandler
extends Node2D


func _process(delta):
	if not Engine.is_editor_hint():
		visible = false
