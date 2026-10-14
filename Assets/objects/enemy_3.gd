extends CharacterBody3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var spawn_location : Vector3
var wander_positions : Array = []
var target_position := 0

func update_targer_location(target_location):
	pass

func _ready() -> void:
	self.global_position = spawn_location
	

func _set_wander_locations():
	for offset in [Vector3(GameVariables.tile_size * 2, 0, 0), Vector3(0, 0, GameVariables.tile_size * 2), Vector3(-GameVariables.tile_size * 2, 0, 0), Vector3(0, 0, -GameVariables.tile_size * 2)]:
		var potential_position = global_transform.origin + offset
		wander_positions.append(potential_position)

func _physics_process(delta: float) -> void:
	if is_on_floor():
		if wander_positions.is_empty():
			_set_wander_locations()
			navigation_agent_3d.set_target_position(wander_positions[target_position % wander_positions.size()])
		elif not navigation_agent_3d.is_target_reachable():
			target_position += 1
			navigation_agent_3d.set_target_position(wander_positions[target_position % wander_positions.size()])
		else:
			var current_location = global_transform.origin
			var next_location = navigation_agent_3d.get_next_path_position()
			var direction = (next_location - current_location).normalized()
			velocity = (direction * GameVariables.enemy_speed)
	else:
		velocity = Vector3(0, -4, 0)
		print("not on floor")
	move_and_slide()


func _on_navigation_agent_3d_target_reached() -> void:
	navigation_agent_3d.set_target_position(wander_positions[target_position % wander_positions.size()])
