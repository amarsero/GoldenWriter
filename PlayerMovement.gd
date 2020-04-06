extends KinematicBody2D


export (int) var run_speed = 130
export (int) var accel = 75
export (int) var jump_speed = -400
export (int) var gravity = 1200
export (int) var friction = 20
export(int, "Writter", "Golden", "Silver") var character

var velocity = Vector2()
var jumping = false
var right = false
var left = false
var jump = false

#var hola = false

var right_input
var left_input
var jump_input

onready var _sprite = $Sprite

func _ready():
	set_inputs()
	
func set_inputs():
	right_input = "player" + str(character) + "_right"
	left_input = "player" + str(character) + "_left"
	jump_input = "player" + str(character) + "_jump"

func get_input():
	right = Input.is_action_pressed(right_input)
	left = Input.is_action_pressed(left_input)
	jump = Input.is_action_pressed(jump_input)

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
	
func add_friction():
	if is_on_floor():
		if !(right || left) && velocity.length() > friction*2:
			velocity = Vector2(0,0)
		else:
			velocity.x += sign(velocity.x) * -friction
			velocity.y += sign(velocity.y) * -friction

func _physics_process(delta):
	
#	if !is_on_floor():
	velocity.y += gravity * delta
	add_friction()
	get_input()
	if jumping and is_on_floor():
		jumping = false
		
	if velocity.x > 0:
		_sprite.flip_h = false
	elif velocity.x < 0:
		_sprite.flip_h = true
	
#	if hola:
#		print(velocity)
#		print(velocity.length())
#	hola = !hola
	
	if (abs(velocity.length()) > friction):
		velocity = move_and_slide(velocity, Vector2(0, -1))
	