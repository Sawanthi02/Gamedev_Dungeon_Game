extends Control
@onready var scores: VBoxContainer = $HBoxContainer/PanelContainer2/MarginContainer2/VBoxContainer/ScrollContainer/Scores
@onready var score_scene = preload("res://scenes/Scorecontainer.tscn")
@onready var play: Button = $HBoxContainer/PanelContainer/VBoxContainer2/VBoxContainer/Play

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play.grab_focus()
	_create_scoreboard()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _create_scoreboard():
	for score in GameScores.LoadScoresSorted():
		var display_score = score_scene.instantiate()
		var name_label = display_score.find_child("Name")
		var score_label = display_score.find_child("Score")
		var time_label = display_score.find_child("Time")
		
		name_label.text = score["name"]
		score_label.text = str(score["score"])
		time_label.text = score["time"]
		
		scores.add_child(display_score)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Map.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings.tscn")


func _on_quit_pressed() -> void:
	get_tree().free()
