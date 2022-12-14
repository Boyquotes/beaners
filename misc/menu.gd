extends VBoxContainer

export(bool) var fade = true
export(bool) var pause_when_visible = false

onready var Animation = $"Animation"

func _ready():
	if fade: Animation.play_backwards("Fade")

func _process(_delta):
	if visible and Interface.always_hide_cursor:
		Interface.always_hide_cursor = false
	elif not visible and not Interface.always_hide_cursor:
		Interface.always_hide_cursor = true

func _on_Play_pressed():
	var _t = get_tree().change_scene("res://maps/tutorial.tscn")

func _on_Quit_pressed():
	App.quit()
