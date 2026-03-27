extends Control


func _process(delta: float) -> void:
	testesc()

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	
	get_tree().paused = true
	$AnimationPlayer.play("blur")


func testesc ():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()


func _on_resume_pressed() -> void:
	resume()


func _on_restart_pressed() -> void:
	reset_player_state()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
	


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	

func reset_player_state():
	SwitchPosition.saved_position = Vector2.ZERO
	SwitchPosition.saved_velocity = Vector2.ZERO
	SwitchPosition.normal_realm = true
	SwitchPosition.saved_time = 0
