extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().current_scene._on_finish_body_entered(body)
