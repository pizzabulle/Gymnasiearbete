extends Control

func _ready() -> void:
	if Music.music_on:
		$PanelContainer/VBoxContainer/Volume.text = "Music: On"
	else:
		$PanelContainer/VBoxContainer/Volume.text = "Music: Off"

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

func _on_volume_pressed() -> void:
	if $PanelContainer/VBoxContainer/Volume.text == "Music: On":
		$PanelContainer/VBoxContainer/Volume.text = "Music: Off"
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
		Music.music_on = false
	else:
		$PanelContainer/VBoxContainer/Volume.text = "Music: On"
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -10)
		Music.music_on = true


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
