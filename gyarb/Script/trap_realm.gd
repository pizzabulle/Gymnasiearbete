extends Area2D

@onready var trap_realm = $Sprite2D

func _ready() -> void:
	SwitchPosition.connect("realm_changed", switch_realm_trap)
	if SwitchPosition.normal_realm == true:
		switch_to_realm_trap()
	elif SwitchPosition.normal_realm == false:
		switch_from_realm_trap()

func _physics_process(delta: float) -> void:
	switch_realm_trap()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.enter_dead_state(body.global_position)
		await get_tree().create_timer(2).timeout
		body.enter_revive_state()	


func switch_to_realm_trap ():
	trap_realm.visible = false


func switch_from_realm_trap ():
	trap_realm.visible = true

func switch_realm_trap():
	if SwitchPosition.normal_realm == true:
		switch_to_realm_trap()
	elif SwitchPosition.normal_realm == false:
		switch_from_realm_trap() 
