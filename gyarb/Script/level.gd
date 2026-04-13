extends Node

const SAVE_PATH = "res://HighScores/Highscores_savefile.dat"

@onready var player: Player = $Player
@onready var block: TileMapLayer = $TileMapPlay
@onready var block_realm: TileMapLayer = $TileMapRealm
@onready var time_label: Label = $HUD/TimeLabel
@onready var highscore_label: Label = $HUD/HighscoreLabel
@onready var change_level: Area2D = $NextLevel
@onready var start_pos: Marker2D = $Marker2D
@onready var bg_music: AudioStreamPlayer2D = $BgMusic

var game_start = false
var can_switch = true
var time: float = 0.0
var game_completed: bool = false
var highscores: Array = []

func _ready() -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"),false) # Sätter igång musiken
	var path = get_tree().current_scene.scene_file_path #
	var file = path.get_file()		#		ser till vilken bana mean är på
	var number = file.get_basename()#
	SwitchPosition.level_nr = int(number.split("_")[1])
	game_start = true
	SwitchPosition.start_pos = start_pos.position

	time = SwitchPosition.saved_time
	if SwitchPosition.saved_position != Vector2.ZERO:
		player.global_position.x = SwitchPosition.saved_position.x #### När man byter level ser detta till att man spawnar rätt position
		if SwitchPosition.saved_position.y < 500:
			player.global_position.y = 845
		else:
			player.global_position.y = 10

	if SwitchPosition.normal_realm == true: #### Realm ändringen 
		switch_from_realm_block()
	elif SwitchPosition.normal_realm == false:
		switch_to_realm_block()
	_load_highscores()
func _physics_process(delta: float) -> void:
	switch_realm_block()
	if not game_completed:
		time += delta
		var time_string = _from_seconds_to_time(time)
		time_label.text = "Time: " + time_string

func switch_to_realm_block():
	block.visible = false
	block_realm.visible = true
	await get_tree().create_timer(0.8).timeout
	can_switch = true

func switch_from_realm_block():
	block.visible = true
	block_realm.visible = false
	await get_tree().create_timer(0.8).timeout
	can_switch = true

func switch_realm_block():
	if Input.is_action_just_pressed("switch") and can_switch:
		can_switch = false
		SwitchPosition.emit_signal("realm_changed")
		if SwitchPosition.normal_realm == true:
			switch_to_realm_block()
			SwitchPosition.normal_realm = false
		elif SwitchPosition.normal_realm == false:
			switch_from_realm_block()
			SwitchPosition.normal_realm = true

func _on_next_level_body_entered(body: Node2D) -> void:
	if body is Player:
		SwitchPosition.level_nr += 1
		SwitchPosition.saved_time = time		# byter level
		LevelManager.change_to_next_level(SwitchPosition.level_nr)
		SwitchPosition.saved_position = player.global_position

func _on_back_level_body_entered(body: Node2D) -> void:
	if body is Player:
		SwitchPosition.level_nr -= 1
		SwitchPosition.saved_time = time
		LevelManager.change_to_last_level(SwitchPosition.level_nr)
		SwitchPosition.saved_position = player.global_position

func _on_last_level_body_entered(body: Node2D) -> void:
	if body is Player:			# Ser till at man inte kan fella ner längst ner
		player.enter_revive_state()

func _on_finish_body_entered(body: Node2D) -> void:
	if body is Player and not game_completed:
		game_completed = true### Målet
		_load_highscores()
		_show_finish_screen()


################Time##############
func _load_highscores() -> void: ## KOllar om highscore filen finns
	highscores = []
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.READ, "G%8vM7Ln")
		if file == null:
			return
		var text = file.get_as_text()
		file.close()
		var data = JSON.parse_string(text)
		if data is Array:
			highscores = data

func _save_highscores() -> void: # Sparar ens tid i highscores listan
	DirAccess.make_dir_recursive_absolute("res://HighScores")
	var file = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.WRITE,"G%8vM7Ln") 
	if file == null:
		return
	file.store_string(JSON.stringify(highscores))
	file.close()

func _qualifies_for_top8() -> bool: # KOllar om man är tilräckligt sanbb för att vara i leaderboard
	if highscores.size() < 8:
		return true
	return time < highscores[highscores.size() - 1]["time"]

func _insert_score(player_name: String) -> void: # Lägger till namn och tid i leaderboard
	highscores.append({"name": player_name, "time": time})
	highscores.sort_custom(func(a, b): return a["time"] < b["time"])
	if highscores.size() > 8:
		highscores.resize(8)
	_save_highscores()

func _show_finish_screen() -> void: # Visar leaderboard
	var finish_scene = preload("res://Scenes/FinishScreen.tscn").instantiate()
	finish_scene.connect("score_submitted", _on_score_submitted)
	add_child(finish_scene)
	finish_scene.setup(time, highscores, _qualifies_for_top8())

func _on_score_submitted(player_name: String) -> void:
	_insert_score(player_name)

func _from_seconds_to_time(seconds: float) -> String: #Timer
	var minu = int(seconds / 60)
	var sec = int(seconds - minu * 60)
	return "%02d:%02d" % [minu, sec]
