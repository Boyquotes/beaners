extends MarginContainer

var default_font_color = Color(1, 1, 1, 1)
var hover_font_color = Color("#D3D3D3")

var is_typing = false
var is_paused = false

onready var AudioOption = $"Root/MarginContents/Contents/AudioOption"
onready var GraphicsOption = $"Root/MarginContents/Contents/GraphicsOption"
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
		if option_selection < 2:
			option_selection += 1
		
		update_opt_selection()
	elif Input.is_action_just_pressed("ui_left") and not is_typing:
		if option_selection > 0:
			option_selection -= 1
		elif option_selection == -1:
			option_selection = 2
		
		update_opt_selection()
		
	# Call handle_opt_selection for the accept input action
	if Input.is_action_just_pressed("ui_accept"):
		handle_opt_selection()
	# Return to main menu for the cancel input action
	if Input.is_action_just_pressed("ui_cancel"):
		if has_node("AudioConfigMenu") and is_ingame():
			return
		
		option_selection = 2
		handle_opt_selection()

func set_ingame(toggle: bool):
	is_paused = toggle

func is_ingame() -> bool:
	return is_paused

func handle_opt_selection():
	# Handle selected option, this is used when pressing the accept input action
	UiSoundGlobals.Select.play()
	
	if option_selection == -1:
		option_selection = 0
	if option_selection == 0:
		if is_paused:
			var menu = preload("res://Scenes/menu/config/AudioConfigMenu.tscn").instance()
			menu.set_ingame(is_paused)
			add_child(menu)
			return
		
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/menu/config/AudioConfigMenu.tscn")
	elif option_selection == 1:
		print("TODO: Implement video configuration screen")
	elif option_selection == 2:
		if is_paused:
			get_parent().remove_child(self)
			queue_free()
			return
		
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Menu.tscn")

func update_opt_selection():
	# This function must be called after option_selection has changed
	# Reset all the options first before doing anything else
	AudioOption.add_color_override("font_color", default_font_color)
	GraphicsOption.add_color_override("font_color", default_font_color)
	BackOption.add_color_override("font_color", default_font_color)
	
	if option_selection != -1: UiSoundGlobals.Navigate.play()
	
	# Then do something to the options depending on the selection
	if option_selection == 0:
		AudioOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 1:
		GraphicsOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 2:
		BackOption.add_color_override("font_color", hover_font_color)

func reset_opt_selection():
	option_selection = -1
	update_opt_selection()

func _on_AudioOption_mouse_entered():
	if option_selection == 0: return
	option_selection = 0
	update_opt_selection()

func _on_GraphicsOption_mouse_entered():
	if option_selection == 1: return
	option_selection = 1
	update_opt_selection()

func _on_BackOption_mouse_entered():
	if option_selection == 2: return
	option_selection = 2
	update_opt_selection()

func _on_AudioOption_mouse_exited():
	reset_opt_selection()

func _on_GraphicsOption_mouse_exited():
	reset_opt_selection()

func _on_BackOption_mouse_exited():
	reset_opt_selection()

func _on_AudioOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 0
		handle_opt_selection()

func _on_GraphicsOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 1
		handle_opt_selection()

func _on_BackOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 2
		handle_opt_selection()
