extends Area2D

@onready var trap_norm = $Sprite2D
@onready var fall = $FallSound

var fall_played = false

func _ready() -> void:
	SwitchPosition.connect("realm_changed", switch_realm_trap)
	if SwitchPosition.normal_realm == true:
		switch_from_realm_trap()
	elif SwitchPosition.normal_realm == false:
		switch_to_realm_trap()

func _on_body_entered(body: Node2D) -> void: # När spelaren kolliderar med bananen ska ett ljud spelas och en fallande animation 
	if body is Player:
		if not fall_played:
			fall.play()
			fall_played = true
		body.enter_dead_state(body.global_position)
		await get_tree().create_timer(2).timeout
		body.enter_revive_state()
		fall_played = false


func switch_to_realm_trap ():
	trap_norm.visible = false


func switch_from_realm_trap ():
	trap_norm.visible = true

func switch_realm_trap(): # Byter realm för bananen
	if SwitchPosition.normal_realm == true:
		switch_to_realm_trap()
	elif SwitchPosition.normal_realm == false:
		switch_from_realm_trap() 
