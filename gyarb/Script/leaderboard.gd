extends Control

const SAVE_PATH = "res://HighScores/Highscores_savefile.dat"

@onready var slots: VBoxContainer = $Panel/VBox/Slots


func _ready() -> void:
	var highscores = []
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open_encrypted_with_pass(SAVE_PATH, FileAccess.READ, "G%8vM7Ln")
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if data is Array:
			highscores = data
	for i in range(highscores.size()):
		var row = HBoxContainer.new()
		var rank = Label.new()
		rank.text = "#%d" % (i + 1)
		rank.custom_minimum_size.x = 32
		var name_lbl = Label.new()
		name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var time_lbl = Label.new()
		name_lbl.text = highscores[i]["name"]
		time_lbl.text = _fmt(highscores[i]["time"])
		row.add_child(rank)
		row.add_child(name_lbl)
		row.add_child(time_lbl)
		slots.add_child(row)

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _fmt(s: float) -> String:
	var m: int = int(s / 60)
	var sec: int = int(s) - m * 60
	return "%02d:%02d" % [m, sec]
