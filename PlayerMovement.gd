extends KinematicBody2D


export (int) var run_speed = 130
export (int) var accel = 75
export (int) var jump_speed = -400
export (int) var gravity = 1200
export (int) var friction = 20

var velocity = Vector2()
var jumping = false
var right = false
var left = false
var jump = false

onready var _sprite = $Sprite

func get_input():
	right = Input.is_action_pressed('move_right')
	left = Input.is_action_pressed('move_left')
	jump = Input.is_action_pressed('move_fowards')

	if !jumping and jump and is_on_floor():
        jumping = true
        velocity.y = jump_speed
	if right:
		velocity.x += accel
		if velocity.x > run_speed:
			velocity.x = run_speed
	if left:
		velocity.x -= accel
		if velocity.x < -run_speed:
			velocity.x = -run_speed
	
func friction():
	if is_on_floor():
		if !(right || left) && velocity.length() > friction*2:
			velocity = Vector2(0,0)
		else:
			velocity.x += sign(velocity.x) * -friction
			velocity.y += sign(velocity.y) * -friction

func _physics_process(delta):
	velocity.y += gravity * delta
	friction()
	get_input()
	if jumping and is_on_floor():
		jumping = false
		
	if velocity.x > 0:
		_sprite.scale.x = 1.0
	elif velocity.x < 0:
		_sprite.scale.x = -1.0
	
#	if hola:
#		print(velocity)
#		print(velocity.length())
#	hola = !hola
	
	if (abs(velocity.length()) > friction):
		velocity = move_and_slide(velocity, Vector2(0, -1))
	