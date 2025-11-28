extends Node



@onready var player: Player = $Player
@onready var time_label: Label = $HUD/TimeLabel
@onready var change_level: Area2D = $NextLevel


var time: float = 0.0
var game_completed : bool = false
var level_completed: bool = false
var highscores: Dictionary = {}

@export var level = 1


func _ready() -> void:
	if SwitchPosition.saved_position != Vector2.ZERO:
		player.global_position.x = SwitchPosition.saved_position.x
		if SwitchPosition.saved_position.y < 500:
			player.global_position.y = 875
		else:
			player.global_position.y = 50

"""

func _process(delta: float) -> void:
	if not game_completed:
		time += delta
		
		var time_string = _from_seconds_to_time(time)
		
		time_label.text = "Time:" + time_string

func _change_level():
	level_completed = true
	LevelManager.change_to_next_level(level)
	
	
	
func _from_seconds_to_time(seconds: float) -> String:
	var min = int(seconds / 60)
	var sec = int(seconds - min*60)
	return "%02d:%02d" % [min, sec]


func _get_highscores() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		highscores = file.get_var()
		file.close()
"""


func _on_next_level_body_entered(body: Node2D) -> void:
	if body is Player:
		LevelManager.change_to_next_level(level)
		SwitchPosition.saved_position = player.global_position
	

		



func _on_back_level_body_entered(body: Node2D) -> void:
	if body is Player:
		LevelManager.change_to_last_level(level)
		SwitchPosition.saved_position = player.global_position
