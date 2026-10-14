extends Node3D
class_name Stairs

signal level_complete

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		emit_signal("level_complete")
