extends Node2D
class_name Weapon

const DUMMY_BULLET : PackedScene = preload("res://entities/bullets/dummy_bullet.tscn")

var shot_interval : Timer = Timer.new()
var is_in_cooldown : bool = false

@export var bullet_speed : int = 2600
@export var bullets_per_shot : int = 6
@export var max_bullets : int = 100
@export var actual_bullets : int = 100
@export var bullets_spread : int  = 80
@export var bullet_life_time : float = 3
@export var rate_of_fire : float = 0.8

@onready var player : PlayerController = get_parent().get_parent()
@onready var progress_bar : ProgressBar = $ProgressBar
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	player.connect('attack', bullet_manager)
	shot_interval.connect('timeout', stop_reload)
	progress_bar.timer = shot_interval
	add_child(shot_interval)

func bullet_manager(is_pressing_shot : bool) -> void:
	if is_pressing_shot and not is_in_cooldown:
		shot_interval.start(rate_of_fire)
		is_in_cooldown = true
		shot()

func shot() -> void:
	var mouse_pos = get_global_mouse_position()
	for n in bullets_per_shot:
		var spread : Vector2 = Vector2(
			mouse_pos.x + randf_range(-bullets_spread, bullets_spread), 
			mouse_pos.y + randf_range(-bullets_spread, bullets_spread)
			)
		var direction : Vector2 = (spread - player.global_position).normalized()
		var bullet := DUMMY_BULLET.instantiate()
		bullet.speed = bullet_speed
		bullet.position = $cannon.global_position
		bullet.direction = direction
		GLOBAL.current_scene.add_child(bullet)
		audio_stream_player.play()

func stop_reload() -> void:
	is_in_cooldown = false
	shot_interval.stop()
