extends Node2D
class_name Weapon

const bullet : PackedScene = preload("uid://3utep7iikpyx")

var shot_interval : Timer = Timer.new()
var is_in_cooldown : bool = false
var objective = Vector2.RIGHT

@export var character : Character = null:
	set(value):
		character = value
		notify_property_list_changed()
	get:
		return character
@export var target_character : ENUMS.Target_characters = ENUMS.Target_characters.PLAYER
@export var bullet_speed : int = 2600
@export var bullets_per_shot : int = 6
@export var max_bullets : int = 100
@export var actual_bullets : int = 100
@export var bullets_spread : int  = 80
@export var bullet_life_time : float = 3
@export var rate_of_fire : float = 0.8
@export var target : Node2D = null

@onready var reload_bar : ProgressBar = $%reload_bar
@onready var audio_stream_player: AudioStreamPlayer = $%shoot_sound

func _ready() -> void:
	character.connect('attack', bullet_manager)
	shot_interval.connect('timeout', stop_reload)
	reload_bar.timer = shot_interval
	add_child(shot_interval)

func _physics_process(delta: float) -> void:
	set_weapon_orientation()

func bullet_manager(is_pressing_shot : bool) -> void:
	if is_pressing_shot and not is_in_cooldown:
		shot_interval.start(rate_of_fire)
		is_in_cooldown = true
		shot()
		
func set_weapon_orientation():
	if character is Enemy:
		if character.is_enemy_detected:
			objective = target.position
			look_at(objective) 
	else:
		objective = get_global_mouse_position()
		look_at(objective) 

func shot() -> void:
	var mouse_pos = objective
	for n in bullets_per_shot:
		var spread : Vector2 = Vector2(
			mouse_pos.x + randf_range(-bullets_spread, bullets_spread), 
			mouse_pos.y + randf_range(-bullets_spread, bullets_spread)
			)
		var direction : Vector2 = (spread - character.global_position).normalized()
		var bullet_instance := bullet.instantiate()
		bullet_instance.target_character = target_character
		bullet_instance.speed = bullet_speed
		bullet_instance.position = $%cannon.global_position
		bullet_instance.direction = direction
		GLOBAL.current_scene.add_child(bullet_instance)
		audio_stream_player.play()

func stop_reload() -> void:
	is_in_cooldown = false
	shot_interval.stop()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if character == null:
		warnings.append("Character is not assigned! This Weapon will not function properly.")
	return warnings
