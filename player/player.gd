extends KinematicBody

enum State {
	IDLE, MOVING, JUMPING, CROUCHING, DEAD
}

const ACCELERATION_DEFAULT = 7
const ACCELERATION_AIR = 1
const GRAVITY_DEFAULT = 9.8
const GRAVITY_MOON = 0.8

var speed = 7
var state = State.IDLE
var acceleration = ACCELERATION_DEFAULT
var gravity = GRAVITY_DEFAULT

var camera_acceleration = 40
var camera_sensitivity = 0.1

var to_jump = false
var to_crouch = false
var to_aim = false

var snap = Vector3.ZERO
var direction = Vector3.ZERO
var velocity = Vector3.ZERO
var _gravity = Vector3.ZERO

onready var Collision = $"Collision"
onready var Head = $"Head"
onready var Camera = $"Head/Camera"

func _ready():
	# Hide the mouse cursor if not hidden
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Receive mouse movement for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * camera_sensitivity))
		Head.rotate_x(deg2rad(-event.relative.y * camera_sensitivity))
		Head.rotation.x = clamp(Head.rotation.x, deg2rad(-89), deg2rad(89))
	# Receive keyboard/joystick inputs for player abilities
	if event.is_action_pressed("player_jump"):
		to_jump = true
	if event.is_action_pressed("player_crouch"):
		to_crouch = true
	elif event.is_action_released("player_crouch"):
		to_crouch = false
	if event.is_action_pressed("player_aim"):
		to_aim = true
	elif event.is_action_released("player_aim"):
		to_aim = false

func _process(delta):
	# Use physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		Camera.set_as_toplevel(true)
		Camera.global_transform.origin = Camera.global_transform.origin.linear_interpolate(Head.global_transform.origin, camera_acceleration * delta)
		Camera.rotation.y = rotation.y
		Camera.rotation.x = Head.rotation.x
	else:
		Camera.set_as_toplevel(false)
		Camera.global_transform = Head.global_transform

func _physics_process(delta):
	# Receive keyboard/joystick input for basic movements
	var f_input = Input.get_action_strength("player_move_down") - Input.get_action_strength("player_move_up")
	var h_input = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
	var h_rotation = global_transform.basis.get_euler().y
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rotation).normalized()
	
	if is_on_floor():
		snap = -get_floor_normal()
		acceleration = ACCELERATION_DEFAULT
		_gravity = Vector3.ZERO
		
		if to_jump:
			snap = Vector3.ZERO
			_gravity = Vector3.UP * 5
			to_jump = false
		if to_crouch:
			Collision.shape.height -= 20 * delta
			speed = 4
		else:
			Collision.shape.height += 20 * delta
			speed = 7
		if to_aim:
			Camera.fov = lerp(Camera.fov, 55, 0.1)
		else:
			Camera.fov = lerp(Camera.fov, 90, 0.1)
	else:
		snap = Vector3.DOWN
		acceleration = ACCELERATION_AIR
		_gravity += Vector3.DOWN * gravity * delta
	
	# Finalize the normalized movement and other stuff
	Collision.shape.height = clamp(Collision.shape.height, 0.5, 1.5)
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 
	var _r = move_and_slide_with_snap(velocity + _gravity, snap, Vector3.UP)
	
	# Update player state depending on movement and gravity
	update_state()

func update_state():
	var g = _gravity.length()
	var v = velocity.length()
	var ch = Collision.shape.height
	
	if v > 0.1:
		state = State.MOVING
	elif g > 0.01:
		state = State.JUMPING
	elif ch < 1.0:
		state = State.CROUCHING
	else:
		state = State.IDLE
