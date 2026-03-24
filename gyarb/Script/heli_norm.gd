extends Path2D

@export var loop = false
@export var speed = 0.1
@export var speed_scale = 0.3
@onready var path = $PathFollow2D
@onready var anim = $AnimationPlayer
@onready var heli_norm = $AnimatableBody2D/Sprite2D

var direction = 1

func _ready() -> void:
	SwitchPosition.connect("realm_changed", switch_realm_heli)
	if SwitchPosition.normal_realm == true:
		switch_from_realm_heli()
	elif SwitchPosition.normal_realm == false:
		switch_to_realm_heli()

	if not loop:
		anim.play("Heli_Norm")
		anim.speed_scale = speed_scale
		set_process(false)

func _process(delta: float) -> void:
	path.progress += speed * direction
	if path.progress_ratio >= 1.0:
		direction = -1
	elif path.progress_ratio <= 0.0:
		direction = 1

func switch_to_realm_heli():
	heli_norm.visible = false

func switch_from_realm_heli():
	heli_norm.visible = true

func switch_realm_heli():
	if SwitchPosition.normal_realm == true:
		switch_to_realm_heli()
	elif SwitchPosition.normal_realm == false:
		switch_from_realm_heli()
