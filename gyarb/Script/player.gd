extends CharacterBody2D
 
class_name Player

const MAX_SPEED = 300
const ACC = 2500
const JUMP_VELOCITY = 600
const GRAVITY = 1250

enum{IDLE, WALK, AIR}

var state = IDLE
var want_to_jump: bool = false
var jump_buffer: float = 0.0


@onready var anim_player: AnimatedSprite2D = $Player
@onready var anim_player_realm: AnimatedSprite2D = $Player_realm
@onready var block: TileMapLayer = $"../TileMapPlay"
@onready var block_realm: TileMapLayer = $"../TileMapRealm"
@onready var player: CharacterBody2D = $"."
@onready var switch_timer: Timer = $"../SwitchTimer"


############### GAME LOOP #####################
func _physics_process(delta: float) -> void:
	
	match state:
		IDLE:
			_idle_state(delta)
		WALK:
			_walk_state(delta)
		AIR:
			_air_state(delta)
	
	if Input.is_action_just_pressed("switch"):
		
		if anim_player.visible == true:
			anim_player.visible = false
			anim_player_realm.visible = true
#			
		else:
			anim_player.visible = true
			anim_player_realm.visible = false
			
		
		

	
	
	if anim_player.visible == true:
		player.set_collision_mask_value(2,true)
		player.set_collision_mask_value(3,false)
		block.visible = true
		block_realm.visible = false
		
	elif anim_player_realm.visible == true:
		player.set_collision_mask_value(3,true)
		player.set_collision_mask_value(2,false)
		block.visible = false
		block_realm.visible = true
	
		

###########GENERAL HELP FUNCTIONS###############
func _movement(delta: float, input_x: float) ->void:
	if up_direction.is_equal_approx(Vector2.UP) or up_direction.is_equal_approx(Vector2.DOWN):
		if input_x != 0:
			velocity.x = move_toward(velocity.x, input_x * MAX_SPEED * (-sin(up_direction.angle())), ACC * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, ACC * delta)
			
		velocity.y += -up_direction.y * GRAVITY * delta
		apply_floor_snap()
		move_and_slide()
	else:
		if input_x != 0:
			velocity.y = move_toward(velocity.y, input_x * MAX_SPEED * (cos(up_direction.angle())), ACC * delta)
		else:
			velocity.y = move_toward(velocity.y, 0, ACC * delta)
		velocity.x += -up_direction.x * GRAVITY * delta
		apply_floor_snap()
		move_and_slide()
		
	


func _update_direction(input_x: float) -> void:
	if input_x > 0:
		anim_player.flip_h = false
		anim_player_realm.flip_h = false
	elif input_x < 0:
		anim_player.flip_h = true
		anim_player_realm.flip_h = true


############## STATE FUNCTION###################
func _idle_state(delta: float) -> void:
	#1
	if Input.is_action_just_pressed("jump"):
		_enter_air_state(true)
	var input_x = Input.get_axis("move left","move right")
	_update_direction(input_x)
	#2
	_movement(delta, input_x)
	if velocity.length() > 0 and is_on_floor():
		_enter_walk_state()
	elif not is_on_floor():
		_enter_air_state(false)
	
func _walk_state(delta: float) -> void:
	#1
	if Input.is_action_just_pressed("jump"):
		_enter_air_state(true)
	var input_x = Input.get_axis("move left","move right")
	_update_direction(input_x)
	#2
	_movement(delta, input_x)
	
	if velocity.length() == 0 and is_on_floor():
		_enter_idle_state()
	elif not is_on_floor():
		_enter_air_state(false)
	
func _air_state(delta: float) -> void:
	#1
	if Input.is_action_just_pressed("jump"):
		want_to_jump = true
	var input_x = Input.get_axis("move left","move right")
	_update_direction(input_x)
	#2
	_movement(delta,input_x)
	if want_to_jump:
		jump_buffer += delta
		if jump_buffer > 0.1:
			want_to_jump = false
			jump_buffer = 0.0
	#3
	if is_on_floor() and want_to_jump:
		_enter_air_state(true)
	elif is_on_floor() and velocity.length() == 0:
		_enter_idle_state()
	elif is_on_floor():
		_enter_walk_state()
		
		
############ ENTER STATE FUNCTIONS ###############
func _enter_idle_state():
	state = IDLE
	anim_player.play("Idle")
	anim_player_realm.play("Idle")

func _enter_walk_state():
	state = WALK
	anim_player.play("Walk")
	anim_player_realm.play("Walk")

func _enter_air_state(jumping: bool):
	state = AIR
	anim_player.play("Air")
	anim_player_realm.play("Air")
	want_to_jump = false
	jump_buffer = 0.0
	if jumping:
		velocity += up_direction * JUMP_VELOCITY
		
		
		
