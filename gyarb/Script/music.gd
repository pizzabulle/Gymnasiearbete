extends Node2D

@onready var bg_music: AudioStreamPlayer2D = $BgMusic

var music_on = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void: # sätter ingång bakrundsmusiken
	if bg_music.playing == false:
		bg_music.playing = true
