extends RigidBody2D

var force = 500
var rotation_speed = 4
var max_speed = 200
var star_positions = []
@onready var thrust_particles: CPUParticles2D = $ThrustParticles
@onready var explosion_particles: CPUParticles2D = $ExplosionParticles
@onready var camera: Camera2D = $Camera2D
@onready var arrow: Sprite2D = $Arrow
@onready var stars_container: Node2D = $"../Stars"
@onready var game_manager: Node = $"../GameManager"
@onready var explosion_sfx: AudioStreamPlayer2D = $ExplosionSFX
@onready var thrust_sfx: AudioStreamPlayer2D = $ThrustSFX


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	star_positions = game_manager.get_star_positions()
	
	if star_positions.size() > 0:
		arrow.visible = true
		
		var direction = (star_positions[-1] - global_position).normalized()
		
		# Вычисляем угол и устанавливаем поворот стрелки
		var angle_radians = direction.angle()
		arrow.global_rotation = angle_radians + PI / 2
	else:
		arrow.visible = false
	
	
func _physics_process(delta):
	var direction = Vector2.UP.rotated(rotation)
	
	if Input.is_action_pressed("move_forward"):
		apply_force(direction * force)
		thrust_particles.set_emitting(true)
		if not thrust_sfx.playing:
			thrust_sfx.play()
	
	if Input.is_action_just_released("move_forward"):
		thrust_particles.set_emitting(false)
		if thrust_sfx.playing:
			thrust_sfx.stop()
		
		
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
	
	angular_velocity = 0
	
	if Input.is_action_pressed("move_left"):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("move_right"):
		rotation += rotation_speed * delta
		
	camera.global_rotation = 0
	
	
