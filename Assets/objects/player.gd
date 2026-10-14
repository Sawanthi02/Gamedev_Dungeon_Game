extends CharacterBody3D
class_name  Player

signal game_over

@onready var navigation_agent_3d: NavigationAgent3D = $CollisionShape3D/NavigationAgent3D
@onready var defeat_audio: AudioStreamPlayer = $"../DefeatAudio"


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir := Input.get_vector("Walk left", "Walk right", "Walk up", "Walk down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x *  GameVariables.player_speed
		velocity.z = direction.z * GameVariables.player_speed
	else:
		velocity.x = move_toward(velocity.x, 0, GameVariables.player_speed)
		velocity.z = move_toward(velocity.z, 0, GameVariables.player_speed)

	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy"):
		emit_signal("game_over")
		defeat_audio.play()

func is_exit_reachable(exit_location: Vector3) -> bool:
	navigation_agent_3d.set_target_position(exit_location)
	var is_reachable = navigation_agent_3d.is_target_reachable()
	return is_reachable
