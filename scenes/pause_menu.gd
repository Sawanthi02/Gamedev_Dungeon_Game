extends Control
@onready var game_over: Control = $"../Game over"
@onready var resume: Button = $Panel/VBoxContainer/Resume
@onready var map: map = $"../.."

var paused := false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause") && game_over.visible == false:
		resume.grab_focus()
		gamePause()

func gamePause():
	paused = !paused
	if paused:
		self.show()
	else :
		self.hide()
	
	get_tree().paused = paused



func _on_resume_pressed() -> void:
	gamePause()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_stuck_pressed() -> void:
	gamePause()
	map.restart()
