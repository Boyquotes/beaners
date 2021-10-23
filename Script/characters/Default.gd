extends KinematicBody

export var speed = 7
export var acceleration = 5
export var gravity = 1.00
export var jump_power = 30

onready var head = $"Head"
onready var third_person_camera = $"Head/ThirdPersonCamera"

var velocity = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	var direction = Vector3()
	
	if Input.is_action_pressed("game_up"):
		direction -= head_basis.z
	elif Input.is_action_pressed("game_down"):
		direction += head_basis.z
	
	if Input.is_action_pressed("game_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("game_right"):
		direction += head_basis.x
	
	if Input.is_action_just_pressed("game_sprint"):
		speed += 8
	elif Input.is_action_just_released("game_sprint"):
		speed -= 8
	
	if Input.is_action_just_pressed("game_jump") and is_on_floor():
		velocity.y += jump_power
	
	if Input.is_action_just_pressed("game_crouch"):
		set_scale(Vector3(1, 0.5, 1))
		third_person_camera.set_rotation_degrees(Vector3(-10, 0, 0))
		speed -= 4
	elif Input.is_action_just_released("game_crouch"):
		set_scale(Vector3(1, 1, 1))
		third_person_camera.set_rotation_degrees(Vector3(-30, 0, 0))
		speed += 4
	
	if Input.is_action_pressed("game_reset"):
		set_translation(Vector3(1, 1, 1))
	
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	velocity = move_and_slide(velocity, Vector3.UP)
