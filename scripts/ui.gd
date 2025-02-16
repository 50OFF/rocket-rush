extends Control

@onready var game_manager: Node = $"../../../GameManager"
@onready var score_label: Label = $ScoreLabel
@onready var pause_button: Button = $PauseButton
@onready var resume_button: Button = $ResumeButton
@onready var main_menu_button: Button = $MainMenuButton
@onready var restart_button: Button = $RestartButton
@onready var final_score_label: Label = $FinalScoreLabel

var menu_scene : PackedScene

var pause = false


func show_results(result: int):
	score_label.visible = false
	pause_button.visible = false
	restart_button.visible = true
	final_score_label.visible = true
	final_score_label.text = "Score: " + str(result)


func _ready() -> void:
	menu_scene = load("res://scenes/menu.tscn")
	Engine.time_scale = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pause_button_pressed() -> void:
	if not pause:
		pause = true
		Engine.time_scale = 0
		resume_button.visible = true
		main_menu_button.visible = true
	else:
		pause = false
		Engine.time_scale = 1
		resume_button.visible = false
		main_menu_button.visible = false


func _on_resume_button_pressed() -> void:
	pause = false
	Engine.time_scale = 1
	resume_button.visible = false
	main_menu_button.visible = false


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(menu_scene)  


func _on_restart_button_pressed() -> void:
	game_manager.restart_scene()
