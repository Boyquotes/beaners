extends VideoPlayer

func _ready():
	Interface.always_hide_cursor = true

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		Interface.always_hide_cursor = false

func _input(event):
	if event.is_pressed():
		proceed()

func finished():
	proceed()

func proceed():
	if not Interface.has_shown_startup: Interface.has_shown_startup = true
	var _m = get_tree().change_scene("res://main.tscn")
