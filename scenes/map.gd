extends Node3D
class_name map

@onready var player: Player = $Player
@onready var enemy_spawner: Node3D = $enemy_spawner
@onready var stairs_node: Node3D = null
@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var progress_audio: AudioStreamPlayer = $ProgressAudio
@onready var defeat_audio: AudioStreamPlayer = $DefeatAudio


const floor_tile = preload("res://Assets/tiles/normal_floor.tscn")
const floor_wall_tile = preload("res://Assets/tiles/floor_with_wall.tscn")
const floor_corner_wall_tile = preload("res://Assets/tiles/floor_with_corner_wall.tscn")
const stairs = preload("res://Assets/tiles/stairs.tscn")

const tile_list = [floor_tile, floor_wall_tile, stairs]
const border_tile_list = [floor_wall_tile, floor_corner_wall_tile]

signal done_loading

func _ready() -> void:
	if get_tree().paused == true:
		get_tree().paused = false
	GameVariables.reset()
	
	var audiosettings = GameSetting.load_audio_setting()
	
	audio_stream_player.volume_db = 20 * log(audiosettings["master_volume"] + 0.001) / log(10)
	progress_audio.volume_db = 20 * log(audiosettings["sfx_volume"] + 0.001) / log(10)
	defeat_audio.volume_db = 20 * log(audiosettings["sfx_volume"] + 0.001) / log(10)
	
	audio_stream_player.play()
	
	
	var spawn_location := Vector3(randi_range(1, GameVariables.dungeon_size-1) *  GameVariables.tile_size, 0, randi_range(1,  GameVariables.dungeon_size-1) *  GameVariables.tile_size)
	player.global_position = spawn_location
	generate_level()

func generate_level():
	stairs_node = null
	navigation_region_3d.navigation_mesh.clear()
	randomize()	
	
	var stairs_x = randi_range(1,  GameVariables.dungeon_size / 2 - 1)
	var stairs_z = randi_range(1,  GameVariables.dungeon_size - 2) 
	
	for x in range( GameVariables.dungeon_size / 2):
			for z in range( GameVariables.dungeon_size):
				var current_tile
				var rotation = 0.0
				if x == 0:
					if z == 0:
						current_tile = floor_corner_wall_tile
						rotation = 90
					elif z ==  GameVariables.dungeon_size - 1:
						current_tile = floor_corner_wall_tile
						rotation = 0
					else:
						current_tile = border_tile_list[randi() % border_tile_list.size()]
						if current_tile == floor_corner_wall_tile:
							rotation = [0, 90][randi() % 2]
				elif z == 0:
					current_tile = border_tile_list[randi() % border_tile_list.size()]
					if current_tile == floor_corner_wall_tile:
							rotation = [90, 180][randi() % 2]
					else:
						rotation = 90
				elif z ==  GameVariables.dungeon_size-1:
					current_tile = border_tile_list[randi() % border_tile_list.size()]
					if current_tile == floor_corner_wall_tile:
							rotation = [0, 270][randi() % 2]
					else:
						rotation = 270
				else:
					rotation = [0, 90, 180, 270][randi() % 4]
					if x == stairs_x and z == stairs_z:
						if randi() % 2 == 0:
							instantiate_tile(stairs, x, z, rotation)
							instantiate_tile_mirror(floor_tile, x, z, rotation)
						else:
							instantiate_tile(floor_tile, x, z, rotation)
							instantiate_tile_mirror(stairs, x, z, rotation)
						continue
					else:
						current_tile = tile_list[randi() % (tile_list.size() - 1)]
					

				instantiate_tile(current_tile, x, z, rotation)
				instantiate_tile_mirror(current_tile, x, z, rotation)
	navigation_region_3d.bake_navigation_mesh()

func instantiate_tile(current_tile, x, z, rotation: int = 0.0):
	var tile_scene: Node3D = current_tile.instantiate()
	if current_tile == stairs:
		tile_scene.connect("level_complete", Callable(self, "_on_level_complete"))
		stairs_node = tile_scene
	tile_scene.transform.origin = Vector3(z *  GameVariables.tile_size, 0, x *  GameVariables.tile_size)
	tile_scene.rotate_y(deg_to_rad(rotation))
	navigation_region_3d.add_child(tile_scene)

func instantiate_tile_mirror(current_tile, x, z, rotation: int = 0.0):
	var tile_scene: Node3D = current_tile.instantiate()
	if current_tile == stairs:
		tile_scene.connect("level_complete", Callable(self, "_on_level_complete"))
		stairs_node = tile_scene
	tile_scene.transform.origin = Vector3(( GameVariables.dungeon_size - 1 - z) *  GameVariables.tile_size, 0, ( GameVariables.dungeon_size - 1 - x) *  GameVariables.tile_size)
	tile_scene.rotate_y(deg_to_rad(rotation + 180))
	navigation_region_3d.add_child(tile_scene)

func _on_level_complete():
	progress_audio.play()
	for child in enemy_spawner.get_children():
		child.free()
	for child in navigation_region_3d.get_children():
		if child.is_in_group("tiles"):
			child.call_deferred("free")
	GameVariables.level_increas()
	call_deferred("generate_level")

func restart():
	for child in enemy_spawner.get_children():
		child.free()
	for child in navigation_region_3d.get_children():
		if child.is_in_group("tiles"):
			child.call_deferred("free")
	call_deferred("generate_level")

func _on_navigation_region_3d_bake_finished() -> void:
	await get_tree().process_frame
	await get_tree().create_timer(0.2)
	
	if player.is_exit_reachable(Vector3(stairs_node.global_position.x, player.global_position.y, stairs_node.global_position.z)):
		emit_signal("done_loading")
	else:
		print("Exit not reachable. Regenerating...")
		restart()
