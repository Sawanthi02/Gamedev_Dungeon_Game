extends PanelContainer
@onready var level: Label = $VBoxContainer/Label
@onready var enemies: Label = $VBoxContainer/Label2
@onready var enemy_speed: Label = $VBoxContainer/Label3
@onready var map_size: Label = $VBoxContainer/Label4
@onready var timer: Label = $VBoxContainer/HBoxContainer/Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	level.text = "LEVEL: " + str(GameVariables.level)
	enemies.text = "Enemy count: " + str(GameVariables.enemy_count)
	enemy_speed.text = "Enemy speed: " + str(GameVariables.enemy_speed)
	map_size.text = "Dungeon size: " + str(GameVariables.dungeon_size)
	
	GameVariables.time += delta
	var minutes: int = fmod(GameVariables.time, 3600)/60
	var seconds: int = fmod(GameVariables.time,60)
	var mseconds: int = fmod(GameVariables.time, 1) * 100
	timer.text = str(minutes) + ": " + str(seconds) + ". " + str(mseconds)
