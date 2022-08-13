extends MarginContainer

var default_font_color = Color(1, 1, 1, 1)
var hover_font_color = Color("#D3D3D3")

var is_typing = false
var config = ConfigFile.new()

onready var ServerAddress = $"Root/Contents/ServerAddress"
onready var ServerPort = $"Root/Contents/ServerPort"
onready var JoinOption = $"Root/Contents/OptionContents/JoinOption"
onready var BackOption = $"Root/Contents/OptionContents/BackOption"
onready var UiBackPlayer = $"UiBackPlayer"
onready var UiNavigatePlayer = $"UiNavigatePlayer"
onready var UiSelectPlayer = $"UiSelectPlayer"

export var option_selection = -1

func _ready():
	# Initialize saved configuration
	config.load("user://game.cfg")
	
	# Set server address and port from saved configuration
	ServerAddress.set_text(config.get_value("Lobby", "remote-server-address", ""))
	ServerPort.set_text(config.get_value("Lobby", "remote-server-port", ""))

func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		# Release edit focus for PlayerName when background is touched or pressed
		if event.is_pressed():
			ServerAddress.release_focus()
			ServerPort.release_focus()
	if event is InputEventMouseMotion:
		# Show the mouse cursor if moved
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventKey:
		# Hide the mouse cursor if a key is pressed
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	# React to left-and-right input actions for options
	if Input.is_action_just_pressed("ui_left") and not is_typing:
		if option_selection > 0:
			option_selection -= 1
		elif option_selection == -1:
			option_selection = 1
		
		update_opt_selection()
	elif Input.is_action_just_pressed("ui_right") and not is_typing:
		if option_selection < 1:
			option_selection += 1
		
		update_opt_selection()
		
	# Call handle_opt_selection for the accept input action
	if Input.is_action_just_pressed("ui_accept"):
		handle_opt_selection()
	# Return to main menu for the cancel input action
	if Input.is_action_just_pressed("ui_cancel"):
		option_selection = 1
		handle_opt_selection()

func handle_opt_selection():
	# Handle selected option, this is used when pressing the accept input action
	if UiNavigatePlayer.is_playing():
		UiNavigatePlayer.stop()
	
	if option_selection != 1:
		UiSelectPlayer.play()
	else:
		UiBackPlayer.play()
	
	if option_selection == -1:
		option_selection = 0
	if option_selection == 0:
		# TODO: Implement join screen
		print("TODO: Implement join screen")
	elif option_selection == 1:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/menu/LobbyMenu.tscn")

func update_opt_selection():
	# This function must be called after option_selection has changed
	# Reset all the options first before doing anything else
	JoinOption.add_color_override("font_color", default_font_color)
	BackOption.add_color_override("font_color", default_font_color)
	
	if option_selection != -1: UiNavigatePlayer.play()
	
	# Then do something to the options depending on the selection
	if option_selection == 0:
		JoinOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 1:
		BackOption.add_color_override("font_color", hover_font_color)

func reset_opt_selection():
	option_selection = -1
	update_opt_selection()

func _on_ServerAddress_text_changed(new_text):
	config.set_value("Lobby", "remote-server-address", new_text)
	config.save("user://game.cfg")

func _on_ServerPort_text_changed(new_text):
	if not new_text.is_valid_integer():
		ServerPort.delete_char_at_cursor()
	
	config.set_value("Lobby", "remote-server-port", new_text)
	config.save("user://game.cfg")

func _on_ServerAddress_focus_entered():
	is_typing = true

func _on_ServerAddress_focus_exited():
	is_typing = false

func _on_ServerPort_focus_entered():
	is_typing = true

func _on_ServerPort_focus_exited():
	is_typing = false

func _on_JoinOption_mouse_entered():
	if option_selection == 0: return
	option_selection = 0
	update_opt_selection()

func _on_BackOption_mouse_entered():
	if option_selection == 1: return
	option_selection = 1
	update_opt_selection()

func _on_JoinOption_mouse_exited():
	reset_opt_selection()

func _on_BackOption_mouse_exited():
	reset_opt_selection()

func _on_JoinOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 0
		handle_opt_selection()

func _on_BackOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 1
		handle_opt_selection()
