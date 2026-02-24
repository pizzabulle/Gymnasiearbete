extends Path2D

@export var loop = false
@export var speed = 2
@export var speed_scale = 0.3

@onready var path = $PathFollow2D
@onready var anim = $AnimationPlayer
@onready var heli_realm = $AnimatableBody2D/Sprite2D





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SwitchPosition.connect("realm_changed", switch_realm_heli)
	if SwitchPosition.normal_realm == true:
		switch_from_realm_heli()
	elif SwitchPosition.normal_realm == false:
		switch_to_realm_heli()
		
	if not loop:
		anim.play("Heli_Realm")
		anim.speed_scale = speed_scale
		set_process(false)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		path.progress += speed



func switch_from_realm_heli ():
	heli_realm.visible = false
	anim.pause()
	


func switch_to_realm_heli ():
	heli_realm.visible = true
	anim.play("Heli_Realm")
	

	



func switch_realm_heli ():
	if SwitchPosition.normal_realm == true:
		switch_to_realm_heli()
	elif SwitchPosition.normal_realm == false:
		switch_from_realm_heli() 
