extends Node



@onready var player: Player = $Player
@onready var block: TileMapLayer = $TileMapPlay
@onready var block_realm: TileMapLayer = $TileMapRealm

@onready var time_label: Label = $HUD/TimeLabel
@onready var change_level: Area2D = $NextLevel


var can_switch = true
var time: float = 0.0
var game_completed : bool = false
var level_completed: bool = false
var highscores: Dictionary = {}

@export var level = 1


func _ready() -> void:
	if SwitchPosition.saved_position != Vector2.ZERO:
		player.global_position.x = SwitchPosition.saved_position.x
		if SwitchPosition.saved_position.y < 500:
			player.global_position.y = 845
			#player.velocity.y = 0.0
		else:
			player.global_position.y = 10
			#player.velocity.y = 0.0
	if SwitchPosition.normal_realm == true:
		switch_from_realm_block()
	elif SwitchPosition.normal_realm == false:
		switch_to_realm_block()
		


func _physics_process(delta: float) -> void:
	switch_realm_block()


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
		LevelManager.change_to_next_level(level)
		SwitchPosition.saved_position = player.global_position
	



func _on_back_level_body_entered(body: Node2D) -> void:
	if body is Player:
		LevelManager.change_to_last_level(level)
		SwitchPosition.saved_position = player.global_position
