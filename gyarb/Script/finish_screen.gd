extends CanvasLayer

signal score_submitted(player_name: String)

@onready var your_time_label: Label = $Panel/VBox/YourTime
@onready var name_input: LineEdit = $Panel/VBox/NameRow/NameInput
@onready var submit_btn: Button = $Panel/VBox/NameRow/SubmitButton
@onready var qualify_row: HBoxContainer = $Panel/VBox/NameRow
@onready var slots: VBoxContainer = $Panel/VBox/Slots
@onready var restart_btn: Button = $Panel/VBox/Buttons/RestartButton
@onready var menu_btn: Button = $Panel/VBox/Buttons/MenuButton

var _time: float = 0.0
var _scores: Array = []
var _qualifies: bool = false
var _submitted: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	submit_btn.pressed.connect(_on_submit)
	name_input.text_submitted.connect(func(_t): _on_submit())

func setup(finish_time: float, scores: Array, qualifies: bool) -> void:
	_time = finish_time
	_scores = scores
	_qualifies = qualifies
	print("setup tid: ", _time)
	print("your_time_label: ", your_time_label)
	your_time_label.text = "Din tid: " + _fmt(_time)
	qualify_row.visible = _qualifies
	_fill_slots()

func _fill_slots(highlight: String = "") -> void:
	for c in slots.get_children():
		c.queue_free()
	for i in range(8):
		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 12)
		var rank = Label.new()
		rank.text = "#%d" % (i + 1)
		rank.custom_minimum_size.x = 32
		var name_lbl = Label.new()
		name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var time_lbl = Label.new()
		if i < _scores.size():
			name_lbl.text = _scores[i]["name"]
			time_lbl.text = _fmt(_scores[i]["time"])
			if highlight != "" and _scores[i]["name"] == highlight:
				for lbl: Label in [rank, name_lbl, time_lbl]:
					lbl.add_theme_color_override("font_color", Color(1.0, 0.8, 0.2))
		else:
			name_lbl.text = "—"
			time_lbl.text = "—"
			for lbl: Label in [rank, name_lbl, time_lbl]:
				lbl.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5, 1.0))
		row.add_child(rank)
		row.add_child(name_lbl)
		row.add_child(time_lbl)
		slots.add_child(row)


func _on_submit() -> void:
	if _submitted:
		return
	var n: String = name_input.text.strip_edges()
	if n == "":
		return
	_submitted = true
	submit_btn.disabled = true
	name_input.editable = false
	score_submitted.emit(n)
	await get_tree().process_frame
	var parent = get_parent()
	if parent and parent.has_method("_load_highscores"):
		parent._load_highscores()
		_scores = parent.highscores
	_fill_slots(n)

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	SwitchPosition.saved_time = 0.0
	SwitchPosition.saved_position = Vector2.ZERO
	SwitchPosition.level_nr = 1
	LevelManager.change_to_next_level(1)

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _fmt(s: float) -> String:
	var m: int = int(s / 60)
	var sec: int = int(s) - m * 60
	return "%02d:%02d" % [m, sec]
