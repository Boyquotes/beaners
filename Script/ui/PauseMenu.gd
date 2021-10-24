extends MarginContainer

var mainmenu = preload("res://Scene/ui/MainMenu.tscn")

onready var world = $"../../"
onready var resume = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Resume"
onready var options = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Options" 
onready var mmenu = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer4/HBoxContainer/MMenu"
onready var quit = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Quit"
onready var navigate_sfx = $"NavigateSfx"
onready var select_sfx = $"SelectSfx"
onready var back_sfx = $"BackSfx"

var current_selection = 0

func _ready():
	update_current_selection()

func _process(_delta):
	if (Input.is_action_just_pressed("ui_up") and current_selection > 0
	   or Input.is_action_just_pressed("ui_down") and current_selection < 3):
		navigate_sfx.play()
	
	if Input.is_action_just_pressed("ui_cancel"):
		back_sfx.play()
		current_selection = 0
		handle_selection()
	
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
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_node("/root/World/Player/Head").set_visible(true)
		queue_free()
	elif current_selection == 1:
		print("Options coming soon!")
	elif current_selection == 2:
		var _scene = get_tree().change_scene_to(mainmenu)
		world.queue_free()
		queue_free()
	elif current_selection == 3:
		get_tree().quit()

func update_current_selection():
	var selection = current_selection
	resume.set_scale(Vector2(1, 1))
	options.set_scale(Vector2(1, 1))
	mmenu.set_scale(Vector2(1, 1))
	quit.set_scale(Vector2(1, 1))
	
	if selection == 0:
		resume.set_scale(Vector2(1.2, 1.2))
	elif selection == 1:
		options.set_scale(Vector2(1.2, 1.2))
	elif selection == 2:
		mmenu.set_scale(Vector2(1.2, 1.2))
	elif selection == 3:
		quit.set_scale(Vector2(1.2, 1.2))
