extends MarginContainer

onready var play = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Play"
onready var options = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Options"
onready var help = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer4/HBoxContainer/Help"
onready var quit = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Quit"
onready var navigate_sfx = $"NavigateSfx"
onready var select_sfx = $"SelectSfx"
onready var back_sfx = $"BackSfx"

var current_selection = 0

func _ready():
	current_selection = 0
	update_current_selection()

func _process(_delta):
	if (Input.is_action_just_pressed("ui_up") and current_selection > 0
	   or Input.is_action_just_pressed("ui_down") and current_selection < 3):
		navigate_sfx.play()
	
	if Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		update_current_selection()
	elif Input.is_action_just_pressed("ui_down") and current_selection < 3:
		current_selection += 1
		update_current_selection()
	elif Input.is_action_just_pressed("ui_accept"):
		select_sfx.play()
		handle_selection()

func handle_selection():
	if current_selection == 0:
		var _scene = get_tree().change_scene("res:///Scene/worlds/Void.tscn")
	elif current_selection == 1:
		print("Options coming soon!")
	elif current_selection == 2:
		print("Help coming soon!")
	elif current_selection == 3:
		get_tree().quit()

func update_current_selection():
	var selection = current_selection
	play.set_scale(Vector2(1, 1))
	options.set_scale(Vector2(1, 1))
	help.set_scale(Vector2(1, 1))
	quit.set_scale(Vector2(1, 1))
	
	if selection == 0:
		play.set_scale(Vector2(1.2, 1.2))
	elif selection == 1:
		options.set_scale(Vector2(1.2, 1.2))
	elif selection == 2:
		help.set_scale(Vector2(1.2, 1.2))
	elif selection == 3:
		quit.set_scale(Vector2(1.2, 1.2))
