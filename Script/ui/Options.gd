extends MarginContainer

onready var sfx_toggle = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer3/HBoxContainer/SfxToggle"
onready var music_toggle = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer2/HBoxContainer/MusicToggle"
onready var shadows_toggle = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer4/HBoxContainer/ShadowsToggle"
onready var back = $"CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer/CenterContainer/HBoxContainer/Back"
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
		sfx_toggle.set_pressed(config.get_value("Audio", "SoundFx", true))
		music_toggle.set_pressed(config.get_value("Audio", "Music", true))
		shadows_toggle.set_pressed(config.get_value("Graphics", "Shadows", false))
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
	
	if Input.is_action_just_pressed("ui_cancel"):
		back_sfx.play()
		current_selection = 3
		handle_selection()
	
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

func _on_SfxToggle_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
				navigate_sfx.play()
				current_selection = 0
				update_current_selection()

func _on_SfxToggle_toggled(pressed):
	config.set_value("Audio", "SoundFx", pressed)

func _on_SfxToggle_mouse_entered():
	current_selection = -1
	update_current_selection()
	select_sfx.play()

func _on_MusicToggle_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
				navigate_sfx.play()
				current_selection = 1
				update_current_selection()

func _on_MusicToggle_toggled(pressed):
	config.set_value("Audio", "Music", pressed)

func _on_MusicToggle_mouse_entered():
	current_selection = -1
	update_current_selection()
	select_sfx.play()

func _on_ShadowsToggle_gui_input(event):
		if event is InputEventMouseButton:
			if event.is_pressed():
				navigate_sfx.play()
				current_selection = 2
				update_current_selection()

func _on_ShadowsToggle_toggled(pressed):
	config.set_value("Graphics", "Shadows", pressed)

func _on_ShadowsToggle_mouse_entered():
	current_selection = -1
	update_current_selection()
	select_sfx.play()

func _on_Back_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			navigate_sfx.play()
			current_selection = 3
			update_current_selection()
			handle_selection()

func _on_Back_mouse_entered():
	current_selection = -1
	update_current_selection()
	select_sfx.play()

func handle_selection():
	if current_selection == 0:
		sfx_toggle.set_pressed(!sfx_toggle.is_pressed())
	elif current_selection == 1:
		music_toggle.set_pressed(!music_toggle.is_pressed())
	elif current_selection == 2:
		shadows_toggle.set_pressed(!shadows_toggle.is_pressed())
	elif current_selection == 3:
		var pmenu = get_node_or_null("/root/PauseMenu")
		var mmenu = get_node_or_null("/root/MainMenu")
		
		if not mmenu == null:
			mmenu.set_process(true)
		elif not pmenu == null:
			pmenu.set_process(true)
		
		config.save("user://settings.cfg")
		queue_free()

func update_current_selection():
	var selection = current_selection
	sfx_toggle.set_scale(Vector2(1, 1))
	music_toggle.set_scale(Vector2(1, 1))
	shadows_toggle.set_scale(Vector2(1, 1))
	back.set_scale(Vector2(1, 1))
	
	if selection == 0:
		sfx_toggle.set_scale(Vector2(1.2, 1.2))
	elif selection == 1:
		music_toggle.set_scale(Vector2(1.2, 1.2))
	elif selection == 2:
		shadows_toggle.set_scale(Vector2(1.2, 1.2))
	elif selection == 3:
		back.set_scale(Vector2(1.2, 1.2))
