extends Node

@onready var score_label: Label = $"../Rocket/Camera2D/Hud/ScoreLabel"
@onready var hud: Control = $"../Rocket/Camera2D/Hud"
@onready var stars_container: Node2D = $"../Stars"
@onready var planets_container: Node2D = $"../Planets"
@onready var rocket: RigidBody2D = $"../Rocket"
@onready var missiles_container: Node2D = $"../Missiles"
@onready var missile_period: Timer = $MissilePeriod
@onready var map_edge: Area2D = $"../MapEdge"


#GAME STATES
var alive = true
var pause = false
var menu = false

const star_scene = preload("res://scenes/star.tscn") as PackedScene
const planet_scene = preload("res://scenes/planet.tscn") as PackedScene
const missile_scene = preload("res://scenes/missile.tscn") as PackedScene
const GREEN_PLANET = preload("res://assets/green_planet.png")
const PURPLE_PLANET = preload("res://assets/purple_planet.png")
const ORANGE_PLANET = preload("res://assets/orange_planet.png")

const planet_sprites = [GREEN_PLANET, PURPLE_PLANET, ORANGE_PLANET]
const planet_scales = [Vector2(2, 2), Vector2(3, 3), Vector2(4, 4), Vector2(5, 5)]

var menu_scene: PackedScene

var star_positions = []
var planet_positions = [Vector2(0, 0)]
var score = 0


func add_point():
	score += 1


func spawn_missile():
	var missile = missile_scene.instantiate()
	var flag = false
	var spawn_radius = 400
	var position
	var rotation
	
	while flag != true:
		position = get_random_position_in_circle(rocket.global_position, spawn_radius - 10, spawn_radius)
		flag = true
		for planet_position in planet_positions:
			if position.distance_to(planet_position) < 100:
				flag = false
	
	var direction = (rocket.global_position - position).normalized()
	var angle_radians = direction.angle()
	
	missile.global_position = position
	missile.rotation = angle_radians
	
	missiles_container.add_child(missile)


func get_star_positions():
	return star_positions


func update_star_positions():
	star_positions.clear()
	
	for star in stars_container.get_children():
		for child in star.get_children():
			if child.name == "Sprite2D":
				star_positions.append(star.global_position)


func spawn_star():
	var star = star_scene.instantiate()
	var flag = false
	var spawn_radius = 650 #Размер круга спавна звезд
	var position
	
	while flag != true:
		position = get_random_position_in_circle(Vector2.ZERO, 0, spawn_radius)
		flag = true
		for planet_position in planet_positions:
			if position.distance_to(planet_position) < 100:
				flag = false
	
	star.global_position = position
	
	stars_container.add_child(star)
	
	update_star_positions()


func spawn_planets(quantity):
	var count = 0
	var planet
	var spawn_radius = 600
	var position
	var flag
	var planet_sprite
	for i in quantity:
		planet = planet_scene.instantiate()
		
		position = get_random_position_in_circle(Vector2.ZERO, 0, spawn_radius)
		
		flag = true
		for existing_position in planet_positions:
			if position.distance_to(existing_position) < 300:
				flag = false
				continue
		if not flag:
			continue
			
		
		planet.global_position = position
		planet_positions.append(position)
		planet_sprite = Sprite2D.new()
		planet_sprite.texture = planet_sprites[randi() % planet_sprites.size()]
		planet.scale = planet_scales[randi() % planet_scales.size()]
		planet.add_child(planet_sprite)
		
		planets_container.add_child(planet)
		count += 1


func death(body: Node2D):
	if body.name == "Rocket":
		map_edge.monitoring = false
		body.set_script(null)
		body.linear_velocity = Vector2.ZERO
		body.get_node('ExplosionParticles').emitting = true
		body.get_node('ThrustParticles').emitting = false
		body.get_node('Arrow').queue_free()
		body.get_node('Sprite2D').queue_free()
		body.get_node('CollisionShape2D').queue_free()
		body.get_node('ThrustSFX').queue_free()
		body.get_node('ExplosionSFX').play()
		alive = false
		hud.show_results(score)


func restart_scene():
	get_tree().reload_current_scene()


func get_random_position_in_circle(center: Vector2, min_radius: float, max_radius: float) -> Vector2:
	# Генерируем случайный угол от 0 до 2π
	var angle = randf() * TAU  
	# Генерируем случайное расстояние между min_radius и max_radius
	var distance = lerp(min_radius, max_radius, sqrt(randf()))  
	# Вычисляем смещение и добавляем к центру
	var random_offset = Vector2(cos(angle), sin(angle)) * distance
	return center + random_offset


func _ready() -> void:
	spawn_planets(10)
	spawn_star()
	menu_scene = load("res://scenes/menu.tscn")
	missile_period.start()
	


func _process(delta: float) -> void:
	if alive:
		score_label.text = "Stars collected: " + str(score)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Rocket":
		death(body)


func _on_missile_period_timeout() -> void:
	spawn_missile()
	missile_period.start()
