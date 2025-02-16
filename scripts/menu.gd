extends Node

var game_scene : PackedScene


func _ready() -> void:
	game_scene = load("res://scenes/game.tscn")


func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)  
