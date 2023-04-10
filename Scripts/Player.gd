extends KinematicBody

const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1

var is_debug_cam = false
var is_game_paused = false

var speed = 7
var gravity = 9.8
var jump = 5

var push = 100

var cam_accel = 40
var mouse_sense = 0.1
var snap = null

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

var HUDOverlay = preload("res://Scenes/overlay/HUDOverlay.tscn").instance()
var PauseOverlay = preload("res://Scenes/overlay/PauseOverlay.tscn").instance()

onready var accel = ACCEL_DEFAULT

onready var Name = $"Overlay/NameViewport/Name"
onready var Head = $"Head"
onready var Camera = $"Head/Camera"
onready var DebugCamera = $"DebugCamera"

func _ready():
	HUDOverlay.set_name("HUDOverlay")
	PauseOverlay.set_name("PauseOverlay")
	
	if is_network_master():
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if not has_node("HUDOverlay"):
			add_child(HUDOverlay)

func _notification(what):
	if what == NOTIFICATION_WM_FOCUS_OUT and \
		is_network_master() and not is_paused():
			pause()

func _input(event):
	if event is InputEventMouseMotion and is_network_master():
			rotate_y(deg2rad(-event.relative.x * mouse_sense))
			Head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
			Head.rotation.x = clamp(Head.rotation.x, deg2rad(-89), deg2rad(89))
			rpc("update_head", Head.get_translation(), Head.get_rotation())

func _process(delta):
	if not is_network_master(): return
	if not is_debug_cam_toggled():
		Camera.make_current()
	if Input.is_action_just_pressed("game_debug_cam"):
		toggle_debug_cam(not is_debug_cam_toggled())
	if Input.is_action_just_pressed("ui_cancel") and not is_paused():
		pause()
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		Camera.set_as_toplevel(true)
		Camera.global_transform.origin = Camera.global_transform.origin.linear_interpolate(Head.global_transform.origin, cam_accel * delta)
		Camera.rotation.y = rotation.y
		Camera.rotation.x = Head.rotation.x
	else:
		Camera.set_as_toplevel(false)
		Camera.global_transform = Head.global_transform

func _physics_process(delta):
	if not is_network_master(): return
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
	if Input.is_action_just_pressed("game_walk"):
		speed -= 3
	elif Input.is_action_just_released("game_walk"):
		speed += 3
	if Input.is_action_just_pressed("game_jump") and is_on_floor():
		snap = Vector3.ZERO
		gravity_vec = Vector3.UP * jump
	
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	movement = velocity + gravity_vec
	
	# warning-ignore:return_value_discarded
	move_and_slide_with_snap(movement, snap, Vector3.UP, true, 4, deg2rad(52))
	rpc("update_player", get_translation())

puppet func update_player(translation: Vector3):
	set_translation(translation)

puppet func update_head(translation: Vector3, rotation: Vector3):
	Head.set_translation(translation)
	Head.set_rotation(rotation)

func pause():
	if is_paused(): return
	
	speed = 0
	jump = 0
	
	if is_debug_cam_toggled():
		DebugCamera.clear_current()
		Camera.make_current()
	if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	PauseOverlay.set_pause_mode(Node.PAUSE_MODE_PROCESS)
	add_child(PauseOverlay)
	is_game_paused = true
	set_process_input(false)
	set_pause_mode(Node.PAUSE_MODE_STOP)

func resume():
	if not is_paused(): return
	
	speed = 7
	jump = 5
	
	if is_debug_cam_toggled():
		Camera.clear_current()
		DebugCamera.make_current()
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	PauseOverlay.set_pause_mode(Node.PAUSE_MODE_STOP)
	is_game_paused = false
	set_process_input(true)
	remove_child(PauseOverlay)

func is_paused() -> bool:
	return is_game_paused

func toggle_debug_cam(enable: bool):
	is_debug_cam = enable
	
	if enable:
		Camera.clear_current()
		DebugCamera.make_current()
		set_process_input(false)
	else:
		DebugCamera.clear_current()
		Camera.make_current()
		set_process_input(true)

func is_debug_cam_toggled() -> bool:
	return is_debug_cam and DebugCamera.is_current()

func set_player_name(value: String):
	Name.set_text(value)

func get_player_name() -> String:
	return Name.get_text()

func set_hud_overlay(hud):
	HUDOverlay = hud

func get_hud_overlay():
	return HUDOverlay
