extends MarginContainer

var world = preload("res:///Scene/worlds/Void.tscn")
var options_scene = load("res:///Scene/ui/Options.tscn")

onready var play = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/Play"
onready var options = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/Options"
onready var help = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer4/HBoxContainer/Help"
onready var quit = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Quit"
onready var navigate_sfx = $"NavigateSfx"
onready var select_sfx = $"SelectSfx"
onready var back_sfx = $"BackSfx"

var config = ConfigFile.new()
var current_selection = 0

func _ready():
	var config_status = config.load("user://settings.cfg")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	update_current_selection()
	
	if config_status == OK:
		if not config.has_section_key("Audio", "SoundFx"):
			config.set_value("Audio", "SoundFx", true)
		if not config.has_section_key("Audio", "Music"):
			config.set_value("Audio", "Music", true)
		
		config.save("user://settings.cfg")
	elif config_status == FAILED:
		OS.alert("Failed to load configuration.", "Error")

func _input(event):
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(_delta):
	if (Input.is_action_just_pressed("ui_up") and current_selection > 0
	   or Input.is_action_just_pressed("ui_down") and current_selection < 3):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		navigate_sfx.play()
	
	if Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		update_current_selection()
	elif Input.is_action_just_pressed("ui_down") and current_selection < 3:
		current_selection += 1
		update_current_selection()
	elif Input.is_action_just_pressed("ui_accept"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		select_sfx.play()
		handle_selection()

func _on_Play_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
				navigate_sfx.play()
				current_selection = 0
				update_current_selection()
				handle_selection()

func _on_Play_mouse_entered():
	current_selection = -1
	update_current_selection()
	select_sfx.play()

func _on_Options_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			navigate_sfx.play()
			current_selection = 1
			update_current_selection()
			handle_selection()

func _on_Options_mouse_entered():
	current_selection = -1
	update_current_selection()
	select_sfx.play()

func _on_Help_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			navigate_sfx.play()
			current_selection = 2
			update_current_selection()
			handle_selection()

func _on_Help_mouse_entered():
	current_selection = -1
	update_current_selection()
	select_sfx.play()

func _on_Quit_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			navigate_sfx.play()
			current_selection = 3
			update_current_selection()
			handle_selection()

func _on_Quit_mouse_entered():
	current_selection = -1
	update_current_selection()
	select_sfx.play()

func handle_selection():
	if current_selection == 0:
		var _scene = get_tree().change_scene_to(world)
	elif current_selection == 1:
		get_tree().root.add_child(options_scene.instance())
		set_process(false)
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
