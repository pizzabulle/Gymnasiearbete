extends Node2D


const LAST_LEVEL = 25
const LEVEL_PATH = "res://Scenes/level_"

func change_to_next_level(current_level:int) -> void:

	if current_level < LAST_LEVEL:
		get_tree().change_scene_to_file(LEVEL_PATH + str(current_level + 1) + ".tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/level_1.tscn") 
		
func change_to_last_level(current_level:int) -> void:
	if current_level > 2:
		
		get_tree().change_scene_to_file(LEVEL_PATH + str(current_level - 1)+ ".tscn")
	else:
		get_tree().change_scene_to_file(LEVEL_PATH + str(current_level)+ ".tscn")
