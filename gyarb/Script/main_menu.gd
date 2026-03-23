extends Control

@onready var anim : AnimationPlayer = $AnimationPlayer


func _on_start_pressed() -> void:
	anim.play("start")
	await anim.animation_finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_leaderboard_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/leaderboard.tscn")
	
	"""
	var finish_scene = preload("res://Scenes/FinishScreen.tscn").instantiate()
	add_child(finish_scene)
"""
