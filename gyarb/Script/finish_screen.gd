extends Control


signal score_submitted(player_name: String) #Highscore Name

@onready var your_time_label: Label = $Panel/VBox/YourTimeLabel
@onready var qualifies_section: Control = $Panel/VBox/QualifiesSection
@onready var name_input: LineEdit = $Panel/VBox/QualifiesSection/NameInput
@onready var submit_button: Button = $Panel/VBox/QualifiesSection/SubmitButton
@onready var scores_container: VBoxContainer = $Panel/VBox/ScoresContainer
@onready var play_again_button: Button = $Panel/VBox/PlayAgainButton
@onready var main_menu_button: Button = $Panel/VBox/MainMenuButton
@onready var anim: AnimationPlayer = $AnimationPlayer

var _finish_time: float
var _highscores: Array
var _qualifies: bool
var _submitted: bool = false

func setup(finish_time: float, highscores: Array, qualifies: bool) -> void:
	_finish_time = finish_time
	_highscores = highscores
	_qualifies = qualifies

func _ready() -> void:
	# Pause the game while screen is shown
	get_tree().paused = true

	your_time_label.text = "Your Time: " + _format_time(_finish_time)
	qualifies_section.visible = _qualifies

	_populate_scores()

	submit_button.pressed.connect(_on_submit_pressed)
	play_again_button.pressed.connect(_on_play_again)
	main_menu_button.pressed.connect(_on_main_menu)
	name_input.text_submitted.connect(func(_t): _on_submit_pressed())

	# Play entrance animation if it exists
	if anim:
		anim.play("enter")

func _populate_scores(highlight_name: String = "") -> void:
	# Clear old entries
	for child in scores_container.get_children():
		child.queue_free()

	for i in range(_highscores.size()):
		var entry = _highscores[i]
		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 16)

		var rank_lbl = Label.new()
		rank_lbl.text = "#%d" % (i + 1)
		rank_lbl.custom_minimum_size.x = 40
		rank_lbl.add_theme_font_size_override("font_size", 18)

		var name_lbl = Label.new()
		name_lbl.text = entry["name"]
		name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_lbl.add_theme_font_size_override("font_size", 18)

		var time_lbl = Label.new()
		time_lbl.text = _format_time(entry["time"])
		time_lbl.add_theme_font_size_override("font_size", 18)

		# Highlight the newly submitted row
		if highlight_name != "" and entry["name"] == highlight_name:
			for lbl in [rank_lbl, name_lbl, time_lbl]:
				lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))

		row.add_child(rank_lbl)
		row.add_child(name_lbl)
		row.add_child(time_lbl)
		scores_container.add_child(row)

func _on_submit_pressed() -> void:
	if _submitted:
		return
	var player_name = name_input.text.strip_edges()
	if player_name == "":
		name_input.placeholder_text = "Enter a name first!"
		return
	_submitted = true
	submit_button.disabled = true
	name_input.editable = false
	score_submitted.emit(player_name)
	# Refresh the board with the new entry highlighted
	await get_tree().process_frame
	# Re-fetch updated scores from parent
	var parent = get_parent()
	if parent.has_method("_load_highscores"):
		parent._load_highscores()
		_highscores = parent.highscores
	_populate_scores(player_name)

func _on_play_again() -> void:
	get_tree().paused = false
	SwitchPosition.saved_time = 0.0
	SwitchPosition.saved_position = Vector2.ZERO
	SwitchPosition.level_nr = 1
	LevelManager.change_to_next_level(1)
	queue_free()

func _on_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _format_time(seconds: float) -> String:
	var minu = int(seconds / 60)
	var sec = int(seconds - minu * 60)
	return "%02d:%02d" % [minu, sec]
