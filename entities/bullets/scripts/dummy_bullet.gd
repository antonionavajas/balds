extends Node2D
class_name Bullet

var direction : Vector2 = Vector2.ZERO
var life_time_timer : Timer = Timer.new()

@export var bounce : bool = false
@export var speed : float = 800.0
@export var damage : int = 5
@export var life_time : float = 0.3

@onready var damage_collider : Area2D = $DamageCollider

func _ready() -> void:
	self.add_child(life_time_timer)
	damage_collider.connect("body_entered", hit)
	damage_collider.connect("area_entered", hit_enemy)
	life_time_timer.wait_time = life_time
	life_time_timer.connect('timeout', timeout)
	life_time_timer.start()

func _init() -> void:
	pass
	
func _physics_process(delta):
	position += direction * speed * delta

func timeout() -> void:
	queue_free()

func hit(body: Node) -> void:
	if not bounce:
		queue_free()
	else:
		var normal =  (global_position - body.global_position).normalized()
		direction.bounce(normal)

func hit_enemy(area: Area2D) -> void:
	if 'enemy_colliders' in area.get_groups():
		queue_free()
