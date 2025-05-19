class_name EnemyBehavior
extends Node2D

@export var range_of_sight : float = 1000
@export var range_of_aggro : float = 1000
@export var range_of_shot : float = 750
@export var delay_to_attack : float = 1.0
@export var target : Node2D = null

@onready var sight_raycast: RayCast2D = %sight_raycast
@onready var aggro_raycast: RayCast2D = %aggro_raycast
@onready var shot_raycast: RayCast2D = %shot_raycast

signal enemy_detected(bool)
signal enemy_in_range(bool)

func _process(delta: float) -> void:
	detecting_enemies()
	check_detection()
	check_aggro()
	check_in_range()

func detecting_enemies():
	if target:
		var direction = (target.global_position - global_position).normalized()
		sight_raycast.target_position = direction * range_of_sight
		aggro_raycast.target_position = direction * range_of_aggro
		shot_raycast.target_position = direction * range_of_shot

func check_detection():
	if sight_raycast.is_colliding():
		emit_signal('enemy_detected', true)
	else: 
		emit_signal('enemy_detected', false)

func check_in_range():
	if shot_raycast.is_colliding():
		emit_signal('enemy_in_range', true)
	else: 
		emit_signal('enemy_in_range', false)

func check_aggro():
	if aggro_raycast.is_colliding():
		emit_signal('enemy_detected', true)
	else: 
		emit_signal('enemy_detected', false)
