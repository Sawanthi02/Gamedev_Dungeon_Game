extends Control
@onready var Score_label: Label = $Panel/VBoxContainer2/MarginContainer/VBoxContainer/Label
@onready var time_label: Label = $Panel/VBoxContainer2/MarginContainer/VBoxContainer/Label2
@onready var map: map = $"../.."
@onready var control: Control = $"../../Player/Camera3D/CanvasLayer/Control"
@onready var line_edit: LineEdit = $Panel/VBoxContainer2/MarginContainer/VBoxContainer/LineEdit
@onready var label_3: Label = $Panel/VBoxContainer2/MarginContainer/VBoxContainer/Label3
@onready var audio_stream_player: AudioStreamPlayer = $"../../AudioStreamPlayer"


var has_saved = false

func GameOver(score, time):
	label_3.visible = false
	Score_label.text = "Score: " + str(score)
	
	var minutes: int = fmod(GameVariables.time, 3600)/60
	var seconds: int = fmod(GameVariables.time,60)
	var mseconds: int = fmod(GameVariables.time, 1) * 100
	
	time_label.text = "Time: " + str(minutes) + ": " + str(seconds) + ". " + str(mseconds)
	control.visible = false
	
	line_edit.grab_focus()
	self.visible = true
	get_tree().paused = true


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_resume_pressed() -> void:
	audio_stream_player.play()
	self.visible = false
	control.visible = true
	get_tree().paused = false
	GameVariables.reset()
	map.restart()
	
func _on_player_game_over() -> void:
	audio_stream_player.stop()
	GameOver(GameVariables.level, "")


func _on_save_score_pressed() -> void:
	if line_edit.text && !has_saved:
		var minutes: int = fmod(GameVariables.time, 3600)/60
		var seconds: int = fmod(GameVariables.time,60)
		var mseconds: int = fmod(GameVariables.time, 1) * 100
		GameScores.SaveScore(line_edit.text, GameVariables.level, str(minutes) + ": " + str(seconds) + ". " + str(mseconds))
		label_3.visible = true
		has_saved = true
