extends Node2D

@onready var bg_music: AudioStreamPlayer2D = $BgMusic
@onready var fall_music: AudioStreamPlayer2D = $FallMusic

var music_on = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if bg_music.playing == false:
		bg_music.playing = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
