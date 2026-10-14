extends Node3D

var enemies := [load("res://Assets/objects/enemy.tscn"), load("res://Assets/objects/enemy2.tscn"), load("res://Assets/objects/enemy3.tscn")]
@onready var player: Player = $"../Player"
@onready var map: map = $".."

func _on_map_done_loading() -> void:
	var stairs_location = map.stairs_node.global_position
	
	for i in range(0, GameVariables.enemy_count):
		var selected_enemy = enemies.pick_random()
		var enemy_instance = selected_enemy.instantiate()
		
		var spawn_location : Vector3
		while true:
			if selected_enemy == enemies[2]:
				spawn_location = stairs_location + Vector3(0,2,0)
			else:
				spawn_location = Vector3((randi_range(1, GameVariables.dungeon_size-1) * GameVariables.tile_size), 1.8, (randi_range(1, GameVariables.dungeon_size-1) * GameVariables.tile_size))
			
			
			if player.global_position.distance_to(spawn_location) < 8 and selected_enemy != enemies[2]:
				spawn_location = Vector3((randi_range(1, GameVariables.dungeon_size-1) * GameVariables.tile_size), 2, (randi_range(1, GameVariables.dungeon_size-1) * GameVariables.tile_size))
				print("retry")
			else:
				enemy_instance.spawn_location = spawn_location
				break
		add_child(enemy_instance)

func _physics_process(delta: float) -> void:
	get_tree().call_group("enemy", "update_targer_location", player.global_position)
