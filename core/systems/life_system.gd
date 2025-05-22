@tool
class_name LifeSystem
extends Node

var is_getting_damage : bool = false
var received_damage : int = 0

@export_category('Life Values')
@export var life : int = 500
@export var max_life : int = 500

@export_category('Damage Over Time')
@export var enabled_dot : bool = false
@export var damage_interval : float = 0.5
@export var damage_timer : float = 0.0

@export_category('Collisions')
@export var damage_area : Area2D:
	set(value):
		damage_area = value
		notify_property_list_changed()
	get:
		return damage_area

@export_flags_2d_physics var collision_layer: int
@export_flags_2d_physics var collision_mask: int

signal dying()

func _ready() -> void:
	on_collide()

func _physics_process(delta):
	if is_getting_damage:
#		TODO this is a bad concept. Rework it
		if enabled_dot:
			damage_timer -= delta
			if damage_timer <= 0.0:
				get_damage(received_damage)
				damage_timer = damage_interval
		else: 
			get_damage(received_damage)

func get_damage(damage: int) -> void:
	life -= damage
	check_alive()
	
func check_alive() -> void:
	if life <= 0: emit_signal("dying")

func get_damage_from(area: Area2D):
	if area.collision_layer & collision_mask:
		var entity := area.owner
		is_getting_damage = true
		received_damage = entity.damage

func stop_getting_damage(area: Area2D):
	if area.collision_layer & collision_mask: is_getting_damage = false

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if damage_area == null:
		warnings.append("Damage Area is not assigned! This Damage Area will not function properly.")
	return warnings

func on_collide():
	if damage_area:
		damage_area.connect('area_entered', get_damage_from)
		damage_area.connect('area_exited', stop_getting_damage)
