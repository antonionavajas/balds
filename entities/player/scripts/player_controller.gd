extends CharacterBody2D
class_name PlayerController

@export var speed : float = 250.0

var is_dashing : bool = false
var dash_vector : Vector2 = Vector2.ZERO
var dash_time : float = 0.5
var dash_timer : float = 0.0
var last_direction : Vector2 = Vector2.ZERO

@onready var weapon_container: Node2D = $weapon_container
@onready var weapon : Weapon = $weapon_container/dummy_weapon

signal attack(bool)

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO

	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("dash"):
		dash_vector = last_direction * speed * 4  
		dash_timer = dash_time
		is_dashing = true
		move_and_slide()
		
		
	last_direction = direction
	direction = direction.normalized()
	velocity = direction * speed
	
	var mouse_position = get_global_mouse_position()
	weapon_container.look_at(mouse_position) 
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('fire'):
		emit_signal("attack", true)
		
	if event.is_action_released('fire'):
		emit_signal("attack", false)
		
	
