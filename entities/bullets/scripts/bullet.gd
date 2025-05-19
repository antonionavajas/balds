extends Node2D
class_name Bullet

var direction : Vector2 = Vector2.ZERO
var life_time_timer : Timer = Timer.new()
var start_position : Vector2
var collision_mask : int = 1
var collision_layer : int = 4

@export_group('Bullet modifiers')
@export var has_life_time : bool = false
@export var life_time : float = 0.3
@export var bounce : bool = false
@export var max_range: float = 1000.0

@export_group('Bullet target')
@export var target_character : ENUMS.Target_characters = ENUMS.Target_characters.PLAYER

@export_group('Bullet stats')
@export var speed : float = 800.0
@export var damage : int = 5

@onready var damage_collider : Area2D = $DamageCollider

func _ready() -> void:
	damage_collider.connect("body_entered", hit)
	damage_collider.connect("area_entered", hit_enemy)
	start_position = global_position 
	set_bullet_layers()
	set_life_time()

func _physics_process(delta):
	position += direction * speed * delta
	var traveled_distance = start_position.distance_to(global_position)
	if traveled_distance >= max_range:
		queue_free()

func set_life_time():
	if has_life_time:
		self.add_child(life_time_timer)
		life_time_timer.wait_time = life_time
		life_time_timer.connect('timeout', timeout)
		life_time_timer.start()

func timeout() -> void:
	queue_free()

func hit(body: Node) -> void:
	if not bounce:
		queue_free()
	else:
		var normal =  (global_position - body.global_position).normalized()
		direction.bounce(normal)

func hit_enemy(area: Area2D) -> void:
	if area.collision_layer & collision_mask:
		queue_free()

func set_bullet_layers():
	collision_layer = ENUMS.COLLISION_LAYERS[target_character].collision_mask
	collision_mask = ENUMS.COLLISION_LAYERS[target_character].collision_layer
	damage_collider.collision_layer = collision_layer
	damage_collider.collision_mask = collision_mask
