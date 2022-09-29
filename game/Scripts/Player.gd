extends KinematicBody

const ACCEL_DEFAULT = 7
const ACCEL_AIR = 1

var debug_cam = false

var speed = 7
var gravity = 9.8
var jump = 5

var push = 100

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

onready var Name = $"Overlay/NameViewport/Name"
onready var Head = $"Head"
onready var Camera = $"Head/Camera"

func _ready():
	HUDOverlay.set_name("HUDOverlay")
	PauseOverlay.set_name("PauseOverlay")
	
	if is_network_master():
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		if has_node("HUDOverlay"): add_child(HUDOverlay)
		if not Camera.is_current(): Camera.make_current()

func _notification(what):
	match what:
		NOTIFICATION_WM_FOCUS_OUT:
			if is_paused():
				return
			
			pause()

func _input(event):
	if event is InputEventMouseMotion and is_network_master() and not is_paused() and not debug_cam:
		rotate_y(deg2rad(-event.relative.x * mouse_sense))
		Head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
		Head.rotation.x = clamp(Head.rotation.x, deg2rad(-89), deg2rad(89))
		rpc("update_head", Head.get_translation(), Head.get_rotation())

func _process(delta):
	if not is_network_master() and debug_cam:
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
	
	if is_paused() and is_on_floor() or debug_cam and is_on_floor():
		var up = Input.is_action_pressed("game_move_up")
		var down = Input.is_action_pressed("game_move_down")
		var left = Input.is_action_pressed("game_move_left")
		var right = Input.is_action_pressed("game_move_right")
		if up or down or left or right: return
	if Input.is_action_just_pressed("game_walk") and is_on_floor():
		speed -= 3
	elif Input.is_action_just_released("game_walk") and is_on_floor():
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
	if is_paused() or debug_cam:
		return
	if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	call_deferred("add_child", PauseOverlay)
	get_tree().set_pause(true)

func resume():
	if not is_paused() or debug_cam:
		return
	if get_node("PauseOverlay").has_node("ConfigMenu"):
		# Workaround for the rest of the menus
		return
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	call_deferred("remove_child", PauseOverlay)
	get_tree().set_pause(false)

func is_paused():
	return has_node("PauseOverlay")

func set_player_name(value: String):
	Name.set_text(value)

func get_player_name() -> String:
	return Name.get_text()

func set_debug_cam(toggle: bool):
	debug_cam = toggle

func is_debug_cam() -> bool:
	return debug_cam

func set_hud_overlay(hud):
	HUDOverlay = hud

func get_hud_overlay():
	return HUDOverlay
