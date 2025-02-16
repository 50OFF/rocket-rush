extends RigidBody2D

@onready var rocket: RigidBody2D = $"../../Rocket"
@onready var explosion_particles: CPUParticles2D = $ExplosionParticles
@onready var game_manager: Node = $"../../GameManager"

var follow_speed = 220
var max_rotation_angle = 10
var rotation_speed = 15

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Направление на игрока
	var target_direction = (rocket.global_position - global_position).normalized()
	var target_angle = target_direction.angle()  # Угол в радианах

	# Ограничение угла поворота
	var angle_difference = wrapf(target_angle - rotation, -PI, PI)  # Разница между углами
	angle_difference = clamp(angle_difference, -deg_to_rad(max_rotation_angle), deg_to_rad(max_rotation_angle))

	# Плавный поворот
	rotation += angle_difference * rotation_speed * delta

	# Перемещение в направлении текущего поворота
	position += Vector2(cos(rotation), sin(rotation)) * follow_speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self:
		explosion_particles.set_emitting(true)
		$ThrustParticles.queue_free()
		$Sprite2D.queue_free()
		$Area2D.queue_free()
		$Timer.start()
		$ExplosionSFX.play()
	if body.name == "Rocket":
		game_manager.death(body)


func _on_timer_timeout() -> void:
	queue_free()
