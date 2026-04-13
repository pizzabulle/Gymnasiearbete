extends Control

func _ready() -> void:# Byter music i så att det såtr antigen att musiken är av eller på när man klickar
	if Music.music_on:
		$PanelContainer/VBoxContainer/Volume.text = "Music: On"
	else:
		$PanelContainer/VBoxContainer/Volume.text = "Music: Off"

func _process(delta: float) -> void:
	testesc()

func resume(): #SÄtter igång spelet igen med en animation
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")


func pause(): #Pausar spelet med en animation
	
	get_tree().paused = true
	$AnimationPlayer.play("blur")


func testesc (): #Kollar om man pausar och om det är paus eller fortsätt med esc
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()


func _on_resume_pressed() -> void:
	resume()

func _on_volume_pressed() -> void: #Stänger av musiken och den är på annars sätts den på
	if $PanelContainer/VBoxContainer/Volume.text == "Music: On":
		$PanelContainer/VBoxContainer/Volume.text = "Music: Off"
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
		Music.music_on = false
	else:
		$PanelContainer/VBoxContainer/Volume.text = "Music: On"
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -10)
		Music.music_on = true


func _on_restart_pressed() -> void: #Startar om från level 1 och ny tid
	reset_player_state()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
	


func _on_main_menu_pressed() -> void: #Går till main menu
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	

func reset_player_state(): # Startar om all data inom spelets gång
	SwitchPosition.saved_position = Vector2.ZERO
	SwitchPosition.saved_velocity = Vector2.ZERO
	SwitchPosition.normal_realm = true
	SwitchPosition.saved_time = 0
