extends Node2D

@onready var star_particles: CPUParticles2D = $CPUParticles2D
@onready var game_manager: Node = $"../../GameManager"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Rocket":
		game_manager.add_point()
		
		star_particles.set_emitting(true)
		$Sprite2D.queue_free()
		$Area2D.queue_free()
		$Timer.start()
		$CollectSFX.play()
		
		game_manager.spawn_star()


func _on_timer_timeout() -> void:
	queue_free()
