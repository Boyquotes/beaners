	extends KinematicBody

export var speed = 10
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 30
export var health = 100

onready var head = $"Head"
onready var third_person_camera = $"Head/ThirdPersonCamera"
onready var hud_overlay = $"Head/HUDOverlay"
onready var walk_sfx = $"WalkSfx"
onready var walk_anim = $"WalkAnim"
onready var debug_overlay = $"../DebugOverlay"

var velocity = Vector3()

func _ready():
	debug_overlay.add_statistics("Position", self, "translation", false)
	debug_overlay.add_statistics("Velocity", self, "velocity", false)
	hud_overlay.set_health(health)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	var direction = Vector3()
	
	if not head.is_visible():
		return
	
	if get_translation().y < -50:
		hud_overlay.set_health(0)
		die()
	
	if (Input.is_action_pressed("game_up")
	   or Input.is_action_pressed("game_down")
	   or Input.is_action_pressed("game_left")
	   or Input.is_action_pressed("game_right")):
		if not walk_anim.is_playing() and is_on_floor():
			walk_anim.play("Player-Walk-Anim")
	
	if Input.is_action_pressed("game_up"):
		direction -= head_basis.z
	elif Input.is_action_pressed("game_down"):
		direction += head_basis.z
	
	if Input.is_action_pressed("game_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("game_right"):
		direction += head_basis.x
	
	if Input.is_action_just_pressed("game_sprint"):
		speed = 15
		walk_anim.set_speed_scale(1.250)
	elif Input.is_action_just_released("game_sprint"):
		walk_anim.set_speed_scale(1)
		speed = 10
	
	if Input.is_action_just_pressed("game_jump") and is_on_floor():
		velocity.y += jump_power
	
	if Input.is_action_just_pressed("game_crouch") and is_on_floor():
		set_scale(Vector3(1, 0.5, 1))
		third_person_camera.set_rotation_degrees(Vector3(-10, 0, 0))
		walk_anim.set_speed_scale(0.8)
		speed = 6
	elif Input.is_action_just_released("game_crouch") and is_on_floor():
		set_scale(Vector3(1, 1, 1))
		third_person_camera.set_rotation_degrees(Vector3(-30, 0, 0))
		walk_anim.set_speed_scale(1)
		speed = 10
	
	if Input.is_action_pressed("game_reset"):
		set_translation(Vector3(1, 0, 1))
	
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	velocity = move_and_slide(velocity, Vector3.UP, true)

func increase_health(hp: int):
	health += hp
	hud_overlay.set_health(health)
	
	if health > 100:
		decrease_health(hp)

func decrease_health(hp: int):
	health -= hp
	hud_overlay.set_health(health)
	
	if health < 1:
		die()

func die():
	head.set_visible(false)
	set_visible(false)
	speed = 10
	walk_anim.set_speed_scale(1)
	yield(get_tree().create_timer(5.0), "timeout")
	health = 100
	set_translation(Vector3(1, 0, 1))
	hud_overlay.set_health(100)
	head.set_visible(true)
	set_visible(true)
