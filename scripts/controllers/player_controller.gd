extends CharacterBody2D
class_name Player

@export var speed : float = 250.0
var life : int = 500
var max_life : int = 500

var is_getting_damage : bool = false
var received_damage : int = 0
var damage_interval : float = 0.5
var damage_timer : float = 0.0

var is_dashing : bool = false
var dash_vector : Vector2 = Vector2.ZERO
var dash_time : float = 0.1
var dash_timer : float = 0.0
var last_direction : Vector2 = Vector2.ZERO

@onready var damage_area : Area2D = $damage_area
@onready var life_bar : LifeBar = $life_bar
@onready var weapon_container: Node2D = $weapon_container
@onready var weapon : Weapon = $weapon_container/dummy_weapon

signal attack(bool)

func _ready() -> void:
	damage_area.connect('area_entered', get_damage)
	damage_area.connect('area_exited', stop_getting_damage)
	life_bar.set_max_life(max_life) 
	life_bar.set_life(life)
	life_bar.set_bar_visibility()

func _physics_process(delta):
	if is_getting_damage:
		damage_timer -= delta
		if damage_timer <= 0.0:
			life -= received_damage
			life_bar.set_life(life)
			life_bar.set_bar_visibility()
			damage_timer = damage_interval
			
	if is_dashing:
		velocity = dash_vector
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
	else:
		movement()
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('fire'):
		emit_signal("attack", true)
		
	if event.is_action_released('fire'):
		emit_signal("attack", false)
		
	if event.is_action_pressed("dash"):
		dash_vector = last_direction * speed * 4  
		dash_timer = dash_time
		is_dashing = true

func movement(): 
	var direction := Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1

	last_direction = direction
	direction = direction.normalized()
	velocity = direction * speed
	
	var mouse_position = get_global_mouse_position()
	weapon_container.look_at(mouse_position)

func get_damage(area: Area2D):
	if 'enemy_colliders' in area.get_groups():
		var enemy : Enemy = area.get_parent()
		is_getting_damage = true
		received_damage = enemy.damage

func stop_getting_damage(area: Area2D):
	if 'enemy_colliders' in area.get_groups():
		is_getting_damage = false
