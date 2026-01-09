extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.enter_dead_state(body.global_position)
		await get_tree().create_timer(0.5).timeout
		body.enter_revive_state()	
