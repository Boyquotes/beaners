extends MarginContainer

var default_font_color = Color(1, 1, 1, 1)
var hover_font_color = Color("#D3D3D3")

var ingame_menu = false
var is_typing = false

onready var AudioOption = $"Root/MarginContents/Contents/AudioOption"
onready var VideoOption = $"Root/MarginContents/Contents/VideoOption"
onready var ControlsOption = $"Root/MarginContents/Contents/ControlsOption"
onready var BackOption = $"Root/MarginContents/Contents/BackOption"

export var option_selection = -1

func _input(event):
	if event is InputEventMouseMotion:
		# Show the mouse cursor if moved
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventKey:
		# Hide the mouse cursor if a key is pressed
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	# React to left-and-right input actions for options
	if Input.is_action_just_pressed("ui_right") and not is_typing:
		if option_selection < 3:
			option_selection += 1
		
		update_opt_selection()
	elif Input.is_action_just_pressed("ui_left") and not is_typing:
		if option_selection > 0:
			option_selection -= 1
		elif option_selection == -1:
			option_selection = 3
		
		update_opt_selection()
		
	# Call handle_opt_selection for the accept input action
	if Input.is_action_just_pressed("ui_accept"):
		handle_opt_selection()
	# Return to main menu for the cancel input action
	if Input.is_action_just_pressed("ui_cancel"):
		option_selection = 3
		handle_opt_selection()

func handle_opt_selection():
	# Handle selected option, this is used when pressing the accept input action
	UiSoundGlobals.Select.play()
	
	if option_selection == -1:
		option_selection = 0
	if option_selection == 0:
		if is_ingame_menu():
			var audio_menu = preload("res://Scenes/menu/config/AudioConfigMenu.tscn").instance()
			audio_menu.toggle_ingame_menu(true)
			set_process_input(false)
			set_process(false)
			add_child(audio_menu)
		else:
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/menu/config/AudioConfigMenu.tscn")
	elif option_selection == 1:
		if is_ingame_menu():
			var video_menu = preload("res://Scenes/menu/config/VideoConfigMenu.tscn").instance()
			video_menu.toggle_ingame_menu(true)
			set_process_input(false)
			set_process(false)
			add_child(video_menu)
		else:
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/menu/config/VideoConfigMenu.tscn")
	elif option_selection == 2:
		print("TODO: Implement controls configuration screen")
	elif option_selection == 3:
		if is_ingame_menu():
			get_parent().set_process_input(true)
			get_parent().set_process(true)
			get_parent().remove_child(self)
			queue_free()
		else:
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/Menu.tscn")

func update_opt_selection():
	# This function must be called after option_selection has changed
	# Reset all the options first before doing anything else
	AudioOption.add_color_override("font_color", default_font_color)
	VideoOption.add_color_override("font_color", default_font_color)
	ControlsOption.add_color_override("font_color", default_font_color)
	BackOption.add_color_override("font_color", default_font_color)
	
	if option_selection != -1: UiSoundGlobals.Navigate.play()
	
	# Then do something to the options depending on the selection
	if option_selection == 0:
		AudioOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 1:
		VideoOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 2:
		ControlsOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 3:
		BackOption.add_color_override("font_color", hover_font_color)

func reset_opt_selection():
	option_selection = -1
	update_opt_selection()

func toggle_ingame_menu(enable: bool):
	ingame_menu = enable

func is_ingame_menu() -> bool:
	return ingame_menu

func _on_AudioOption_mouse_entered():
	if option_selection == 0: return
	option_selection = 0
	update_opt_selection()

func _on_VideoOption_mouse_entered():
	if option_selection == 1: return
	option_selection = 1
	update_opt_selection()

func _on_ControlsOption_mouse_entered():
	if option_selection == 2: return
	option_selection = 2
	update_opt_selection()

func _on_BackOption_mouse_entered():
	if option_selection == 3: return
	option_selection = 3
	update_opt_selection()

func _on_AudioOption_mouse_exited():
	reset_opt_selection()

func _on_VideoOption_mouse_exited():
	reset_opt_selection()

func _on_ControlsOption_mouse_exited():
	reset_opt_selection()

func _on_BackOption_mouse_exited():
	reset_opt_selection()

func _on_AudioOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 0
		handle_opt_selection()

func _on_VideoOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 1
		handle_opt_selection()

func _on_ControlsOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 2
		handle_opt_selection()

func _on_BackOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 3
		handle_opt_selection()
