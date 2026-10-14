extends CharacterBody3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var spawn_location : Vector3

func update_targer_location(target_location):
	navigation_agent_3d.target_position = target_location

func _ready() -> void:
	self.global_position = spawn_location

func _physics_process(delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = navigation_agent_3d.get_next_path_position()
	var direction = (next_location - current_location).normalized()
	velocity = direction * GameVariables.enemy_speed * 0.75
	move_and_slide()
