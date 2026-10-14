extends RigidBody3D

var spawn_location : Vector3

func _ready() -> void:
	self.global_position = spawn_location
	linear_velocity = Vector3(200, 0, 200).normalized() * GameVariables.enemy_speed

func _process(delta: float) -> void:
	var collision = move_and_collide(linear_velocity * delta)
	if collision:
		linear_velocity = linear_velocity.bounce(collision.get_normal()).normalized() * GameVariables.enemy_speed

func update_targer_location(target_location):
	pass
