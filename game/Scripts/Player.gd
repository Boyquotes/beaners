extends KinematicBody

const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1

var speed = 7
var gravity = 9.8
var jump = 5

var cam_accel = 40
var mouse_sense = 0.1
var snap

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

var HUDOverlay = preload("res://Scenes/overlay/HUDOverlay.tscn").instance()
var PauseOverlay = preload("res://Scenes/overlay/PauseOverlay.tscn").instance()

onready var accel = ACCEL_DEFAULT

onready var Head = $"Head"
onready var Camera = $"Head/Camera"

func _ready():
	HUDOverlay.set_name("HUDOverlay")
	PauseOverlay.set_name("PauseOverlay")
	
	if is_network_master():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		add_child(HUDOverlay)

func _input(event):
	if event is InputEventMouseMotion and is_network_master() and not is_paused():
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		Head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		Head.rotation.x = clamp(Head.rotation.x, deg2rad(-89), deg2rad(89))
		rpc("update_head", Head.get_translation(), Head.get_rotation())

func _process(delta):
	if not is_network_master():
		return
	if Input.is_action_just_pressed("ui_cancel"):
		if not is_paused():
			pause()
		else:
			resume()
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		Camera.set_as_toplevel(true)
		Camera.global_transform.origin = Camera.global_transform.origin.linear_interpolate(Head.global_transform.origin, cam_accel * delta)
		Camera.rotation.y = rotation.y
		Camera.rotation.x = Head.rotation.x
	else:
		Camera.set_as_toplevel(false)
		Camera.global_transform = Head.global_transform

func _physics_process(delta):
	if not is_network_master() and not is_paused(): return
	direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("game_move_down") - Input.get_action_strength("game_move_up")
	var h_input = Input.get_action_strength("game_move_right") - Input.get_action_strength("game_move_left")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	if is_on_floor():
		snap = -get_floor_normal()
		accel = ACCEL_DEFAULT
		gravity_vec = Vector3.ZERO
	else:
		snap = Vector3.DOWN
		accel = ACCEL_AIR
		gravity_vec += Vector3.DOWN * gravity * delta
	
	if Input.is_action_just_pressed("game_jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	
	# warning-ignore:return_value_discarded
	move_and_slide_with_snap(movement, snap, Vector3.UP)
	rpc("update_player", get_translation())

puppetsync func update_player(translation: Vector3):
	set_translation(translation)

puppetsync func update_head(translation: Vector3, rotation: Vector3):
	Head.set_translation(translation)
	Head.set_rotation(rotation)

func pause():
	if is_paused(): return
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().set_pause(true)
	add_child(PauseOverlay)
	remove_child(HUDOverlay)

func resume():
	if not is_paused(): return
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().set_pause(false)
	remove_child(PauseOverlay)
	add_child(HUDOverlay)

func is_paused():
	return has_node("PauseOverlay")

func set_hud_overlay(hud):
	HUDOverlay = hud

func get_hud_overlay():
	return HUDOverlay
