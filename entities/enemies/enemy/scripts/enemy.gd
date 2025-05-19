class_name Enemy
extends Character

var movement_speed: int = 200
var damage : int = 5
@export var is_enemy_detected : bool = false
var is_enemy_in_range : bool = false

@export var life_system : LifeSystem = null:
	set(value):
		life_system = value
		notify_property_list_changed()
	get:
		return life_system

@onready var sprite : Sprite2D = $Sprite2D
@onready var life_bar : LifeBar = $%life_bar
@onready var weapon: Weapon = $%Weapon
@onready var enemy_behavior: EnemyBehavior = $%EnemyBehavior

func _ready() -> void:
	life_system.connect('dying', die)
	enemy_behavior.connect('enemy_detected', follow_enemy)
	enemy_behavior.connect('enemy_in_range', shot_enemy)
	
func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	if GLOBAL.player:
		weapon.target = GLOBAL.player
		enemy_behavior.target = GLOBAL.player
		if is_enemy_detected: 
			direction = GLOBAL.player.position - position
			direction = direction.normalized()
			velocity = direction * movement_speed
			move_and_slide()
		if is_enemy_in_range: 
			emit_signal("attack", true)

func follow_enemy(is_detected):
	is_enemy_detected = is_detected
	
func shot_enemy(is_in_range):
	is_enemy_in_range = is_in_range

func die():
	queue_free()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if life_system == null:
		warnings.append("LifeSystem is not assigned! This LifeBar will not function properly.")
	return warnings
