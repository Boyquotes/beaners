extends CanvasLayer

var default_font_color = Color(1, 1, 1, 1)
var hover_font_color = Color("#D3D3D3")

onready var ResumeOption = $"MarginOverlay/Root/MarginContents/Contents/ResumeOption"
onready var DisconnectOption = $"MarginOverlay/Root/MarginContents/Contents/DisconnectOption"
onready var SettingsOption = $"MarginOverlay/Root/MarginContents/Contents/SettingsOption"
onready var QuitOption = $"MarginOverlay/Root/MarginContents/Contents/QuitOption"

export var option_selection = -1

func _input(event):
	if event is InputEventMouseMotion:
		# Show the mouse cursor if moved
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventKey:
		# Hide the mouse cursor if a key is pressed
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	# React to escape key for resuming the game
	if Input.is_action_just_pressed("ui_cancel"):
		option_selection = 0
		handle_opt_selection()
	
	# React to left-and-right input actions for options
	if Input.is_action_just_pressed("ui_right"):
		if option_selection < 3:
			option_selection += 1
		
		update_opt_selection()
	elif Input.is_action_just_pressed("ui_left"):
		if option_selection > 0:
			option_selection -= 1
		elif option_selection == -1:
			option_selection = 3
		
		update_opt_selection()
		
	# Call handle_opt_selection for the accept input action
	if Input.is_action_just_pressed("ui_accept"):
		handle_opt_selection()

func handle_opt_selection():
	# Handle selected option, this is used when pressing the accept input action
	if option_selection == -1:
		option_selection = 0
	if option_selection == 0:
		if not get_parent().has_method("resume"):
			return
		
		get_parent().set_pause_mode(Node.PAUSE_MODE_INHERIT)
		get_parent().resume()
	elif option_selection == 1:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/menu/LobbyMenu.tscn")
	elif option_selection == 2:
		var menu = preload("res://Scenes/menu/ConfigMenu.tscn").instance()
		menu.toggle_ingame_menu(true)
		set_process_input(false)
		set_process(false)
		add_child(menu)
	elif option_selection == 3:
		AppWatcher.quit()

func update_opt_selection():
	# This function must be called after option_selection has changed
	# Reset all the options first before doing anything else
	ResumeOption.add_color_override("font_color", default_font_color)
	DisconnectOption.add_color_override("font_color", default_font_color)
	SettingsOption.add_color_override("font_color", default_font_color)
	QuitOption.add_color_override("font_color", default_font_color)
	
	# Then do something to the options depending on the selection
	if option_selection == 0:
		ResumeOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 1:
		DisconnectOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 2:
		SettingsOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 3:
		QuitOption.add_color_override("font_color", hover_font_color)

func reset_opt_selection():
	option_selection = -1
	update_opt_selection()

func _on_ResumeOption_mouse_entered():
	if option_selection == 0: return
	option_selection = 0
	update_opt_selection()

func _on_DisconnectOption_mouse_entered():
	if option_selection == 1: return
	option_selection = 1
	update_opt_selection()

func _on_SettingsOption_mouse_entered():
	if option_selection == 2: return
	option_selection = 2
	update_opt_selection()

func _on_QuitOption_mouse_entered():
	if option_selection == 3: return
	option_selection = 3
	update_opt_selection()

func _on_ResumeOption_mouse_exited():
	reset_opt_selection()

func _on_DisconnectOption_mouse_exited():
	reset_opt_selection()

func _on_SettingsOption_mouse_exited():
	reset_opt_selection()

func _on_QuitOption_mouse_exited():
	reset_opt_selection()

func _on_ResumeOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 0
		handle_opt_selection()

func _on_DisconnectOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 1
		handle_opt_selection()

func _on_SettingsOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 2
		handle_opt_selection()

func _on_QuitOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 3
		handle_opt_selection()
