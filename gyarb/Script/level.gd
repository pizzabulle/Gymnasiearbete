extends Node

const SAVE_PATH = "user://gravityplatformer_savefile.data"


@onready var player: Player = $Player
@onready var block: TileMapLayer = $TileMapPlay
@onready var block_realm: TileMapLayer = $TileMapRealm
@onready var time_label: Label = $HUD/TimeLabel
@onready var highscore_label: Label = $HUD/HighscoreLabel
@onready var change_level: Area2D = $NextLevel


var can_switch = true
var time: float = 0.0
var game_completed : bool = false
var highscores: Dictionary = {}




func _ready() -> void:
	time = SwitchPosition.saved_time
	if SwitchPosition.saved_position != Vector2.ZERO:
		player.global_position.x = SwitchPosition.saved_position.x
		if SwitchPosition.saved_position.y < 500:
			player.global_position.y = 845
		else:
			player.global_position.y = 10

	if SwitchPosition.normal_realm == true:
		switch_from_realm_block()
	elif SwitchPosition.normal_realm == false:
		switch_to_realm_block()
	


func _physics_process(delta: float) -> void:
	switch_realm_block()
	if player.get_collision_layer_value(3):
		print("norm")
	#elif player.get_collision_mask_value(4):
		#print("realm")
	if not game_completed:
		time += delta
		var time_string = _from_seconds_to_time(time)
		time_label.text = "Time:" + time_string


func _finish_game():
	game_completed = true
	if name in highscores:
		if time < highscores[name]:
			_save_highscore(name)
	else:
		_save_highscore(name)

func _get_highscores() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		highscores = file.get_var()
		file.close()

func _save_highscore(level_name: String) -> void:
	highscores[level_name] = time #Ändrar på värdet om det finns eller lägger till om det inte finns
	var file = FileAccess.open(SAVE_PATH,FileAccess.WRITE) # finns ej filen skapas den automatiskt
	file.store_var(highscores)
	file.close()

func _from_seconds_to_time(seconds: float) -> String:
	var min = int(seconds / 60)
	var sec = int(seconds - min*60)
	return "%02d:%02d" % [min, sec]

func switch_to_realm_block():
	block.visible = false
	block_realm.visible = true
	await get_tree().create_timer(0.5).timeout
	can_switch = true



func switch_from_realm_block():
	block.visible = true
	block_realm.visible = false
	await get_tree().create_timer(0.5).timeout
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
		SwitchPosition.level_nr +=1
		SwitchPosition.saved_time = time
		LevelManager.change_to_next_level(SwitchPosition.level_nr)
		SwitchPosition.saved_position = player.global_position

	



func _on_back_level_body_entered(body: Node2D) -> void:
	if body is Player:
		SwitchPosition.level_nr -= 1
		SwitchPosition.saved_time = time
		LevelManager.change_to_last_level(SwitchPosition.level_nr)
		SwitchPosition.saved_position = player.global_position

	



func _on_last_level_body_entered(body: Node2D) -> void:
	if body is Player:
		player.enter_revive_state()



func _on_finish_body_entered(body: Node2D) -> void:
	if body is Player:
		_finish_game()
		_get_highscores()
	if name in highscores:
		var time_string = _from_seconds_to_time(highscores[name])
		highscore_label.text = "Best: " + time_string
	else:
		highscore_label.text = ""
		
