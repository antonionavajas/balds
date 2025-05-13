extends CharacterBody2D
class_name Enemy

var max_life : int = 200
var life : int = 200
var movement_speed: int = 200
var damage : int = 5

@onready var sprite : Sprite2D = $Sprite2D
@onready var damage_area : Area2D = $damage_area
@onready var damage_shape : CollisionShape2D = $damage_area/get_damage_shape
@onready var life_bar : LifeBar = $life_bar

func _ready() -> void:
	damage_area.connect('area_entered', get_damage)
	life_bar.set_max_life(max_life) 
	life_bar.set_life(life)
	life_bar.set_bar_visibility()

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	if GLOBAL.player:
		sprite.look_at(GLOBAL.player.position) 
		direction = GLOBAL.player.position - position
		direction = direction.normalized()
		velocity = direction * movement_speed
		move_and_slide()

func get_damage(area: Area2D):
	if 'bullet_colliders' in area.get_groups():
		var bullet : Bullet = area.get_parent()
		life -= bullet.damage
		life_bar.set_life(life)
		check_alive()
		life_bar.set_bar_visibility()
		
func check_alive():
	if life <= 0:
		queue_free()
