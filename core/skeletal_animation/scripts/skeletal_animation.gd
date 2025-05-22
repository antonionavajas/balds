@tool
class_name SkeletalAnimation
extends Node2D

# TODO outside
#@onready var character_atlas: Sprite2D = $character_atlas
#@onready var polygons: Node2D = $polygons
@onready var animation_player: AnimationPlayer = $AnimationPlayer
#
#func _ready() -> void:
	#for polygon : Polygon2D in polygons.get_children():
		#polygon.texture = character_atlas.texture
