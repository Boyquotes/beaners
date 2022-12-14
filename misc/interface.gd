extends Node

var always_hide_cursor = false
var can_pause = false
var has_shown_startup = false
var is_in_session = false

func _process(_delta):
	if is_in_session:
		always_hide_cursor = true
	if always_hide_cursor and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif not always_hide_cursor and Input.mouse_mode != Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
