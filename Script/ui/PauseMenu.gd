extends MarginContainer

var mainmenu = preload("res://Scene/ui/MainMenu.tscn")
var options_scene = load("res://Scene/ui/Options.tscn")

onready var world = $"/root/World"
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

func _on_Resume_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
				navigate_sfx.play()
				current_selection = 0
				update_current_selection()
				handle_selection()

func _on_Resume_mouse_entered():
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

func _on_MMenu_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			navigate_sfx.play()
			current_selection = 2
			update_current_selection()
			handle_selection()

func _on_MMenu_mouse_entered():
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
		var head = get_node("/root/World/Player/Head")
		var first_person_camera = get_node("/root/World/Player/Head/FirstPersonCamera")
		var hud_overlay_target = get_node("/root/World/Player/Head/HUDOverlay/Target")
		var hud_overlay_health = get_node("/root/World/Player/Head/HUDOverlay/Health")
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		head.set_visible(true)
		hud_overlay_health.set_visible(true)
		
		if first_person_camera.is_current():
			hud_overlay_target.set_visible(true)
		
		queue_free()
	elif current_selection == 1:
		get_tree().root.add_child(options_scene.instance())
		set_process(false)
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
