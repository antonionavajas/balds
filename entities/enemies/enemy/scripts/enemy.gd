class_name Enemy
extends Character

var movement_speed: int = 200
var damage : int = 5
var is_enemy_in_range : bool = false

@export var is_enemy_detected : bool = false
@export var life_system : LifeSystem = null:
	set(value):
		life_system = value
		notify_property_list_changed()
	get:
		return life_system
		
@onready var skeletal_animation: SkeletalAnimation = $%SkeletalAnimation
@onready var life_bar : LifeBar = $%life_bar
@onready var weapon: Weapon = $%Weapon
@onready var enemy_behavior: EnemyBehavior = $%EnemyBehavior
@onready var sub_viewport: SubViewport = $SubViewport
@onready var mesh_instance_2d: MeshInstance2D = $MeshInstance2D

func _ready() -> void:
	life_system.connect('dying', die)
	enemy_behavior.connect('enemy_detected', follow_enemy)
	enemy_behavior.connect('enemy_in_range', shot_enemy)
	skeletal_animation.animation_player.play('idle')
	
func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	
	
	
	if GLOBAL.player:
		weapon.target = GLOBAL.player
		enemy_behavior.target = GLOBAL.player
		if is_enemy_detected: 
			direction = GLOBAL.player.position - position
			direction = direction.normalized()
			if direction.x > 0:
				mesh_instance_2d.scale.x = 1
			else:
				mesh_instance_2d.scale.x = -1
			velocity = direction * movement_speed
			skeletal_animation.animation_player.play('run')
			move_and_slide()
		if is_enemy_in_range: 
			emit_signal("attack", true)
		if not is_enemy_detected:
			skeletal_animation.animation_player.play('idle')

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
