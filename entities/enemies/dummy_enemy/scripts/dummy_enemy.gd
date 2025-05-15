extends CharacterBody2D
class_name Enemy

var movement_speed: int = 200
var damage : int = 5

@export var life_system : LifeSystem = null:
	set(value):
		life_system = value
		notify_property_list_changed()
	get:
		return life_system

@onready var sprite : Sprite2D = $Sprite2D
@onready var life_bar : LifeBar = $life_bar

func _ready() -> void:
	life_system.connect('dying', die)

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	if GLOBAL.player:
		sprite.look_at(GLOBAL.player.position) 
		direction = GLOBAL.player.position - position
		direction = direction.normalized()
		velocity = direction * movement_speed
		move_and_slide()

func die():
	queue_free()
		
func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if life_system == null:
		warnings.append("LifeSystem is not assigned! This LifeBar will not function properly.")
	return warnings
