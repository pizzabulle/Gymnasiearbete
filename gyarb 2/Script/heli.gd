extends Path2D

@export var loop = false
@export var speed = 2
@export var speed_scale = 0.3

var can_switch = true

@onready var path = $PathFollow2D
@onready var anim = $AnimationPlayer
@onready var heli_up_norm = $"."
@onready var heli_side_norm = $"."
@onready var heli_up_realm = $"."
@onready var heli_side_realm = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not loop:
		anim.play("Heli_Up")
		anim.play("Heli_Side")
		anim.speed_scale = speed_scale
		set_process(false)
	
	if SwitchPosition.normal_realm == true	:
		switch_from_realm_heli()
	elif SwitchPosition.normal_realm == false:
		switch_to_realm_heli()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path.progress += speed

func _physics_process(delta: float) -> void:
	switch_realm_heli()
	print(SwitchPosition.normal_realm)




func switch_to_realm_heli ():
	heli_up_norm.visible = false
	heli_side_norm.visible = false
	heli_up_realm.visible = true
	heli_side_realm.visible = true
	await get_tree().create_timer(0.5).timeout
	can_switch = true
	

func switch_from_realm_heli ():
	heli_up_norm.visible = true
	heli_side_norm.visible = true
	heli_up_realm.visible = false
	heli_side_realm.visible = false	
	await get_tree().create_timer(0.5).timeout
	can_switch = true

func switch_realm_heli ():
	if Input.is_action_just_pressed("switch") and can_switch:
		can_switch = false
		if SwitchPosition.normal_realm == true:
			switch_from_realm_heli()
			SwitchPosition.normal_realm == false
		elif SwitchPosition.normal_realm == false:
			switch_to_realm_heli() 
			SwitchPosition.normal_realm == true
