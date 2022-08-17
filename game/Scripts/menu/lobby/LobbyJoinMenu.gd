extends MarginContainer

var default_font_color = Color(1, 1, 1, 1)
var hover_font_color = Color("#D3D3D3")

var is_typing = false
var is_connecting = false

onready var ServerAddress = $"Root/Contents/ServerAddress"
onready var ServerPort = $"Root/Contents/ServerPort"
onready var Error = $"Root/Contents/Error"
onready var ConnectOption = $"Root/Contents/OptionContents/ConnectOption"
onready var BackOption = $"Root/Contents/OptionContents/BackOption"

export var option_selection = -1

func _ready():
	# Set server address and port from saved configuration
	ServerAddress.set_text(ConfigWatcher.get_lobby_config().get_remote_server_address())
	ServerPort.set_text(ConfigWatcher.get_lobby_config().get_remote_server_port())
	
	# Connect network connection signals to related functions
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_lobby_connection_success")
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_lobby_connection_fail")

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
	if not is_connecting:
		UiSoundGlobals.Select.play()
	else:
		UiSoundGlobals.Inaccessible.play()
		return

	if option_selection == -1:
		option_selection = 0
	if option_selection == 0:
		var peer = NetworkedMultiplayerENet.new()
		
		var err = peer.create_client(ServerAddress.get_text(),
			int(ServerPort.get_text()))
		
		if err == ERR_CANT_CREATE:
			set_error("Cannot connect to lobby, there might be a server error.")
			return
		elif err == ERR_ALREADY_IN_USE:
			set_error("You're already connected to this lobby, restarting the game may fix this issue.")
			return
		
		set_connecting(true)
		get_tree().set_network_peer(peer)
	elif option_selection == 1:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/menu/LobbyMenu.tscn")

func update_opt_selection():
	# This function must be called after option_selection has changed
	# Reset all the options first before doing anything else
	ConnectOption.add_color_override("font_color", default_font_color)
	BackOption.add_color_override("font_color", default_font_color)
	
	if option_selection != -1: UiSoundGlobals.Navigate.play()
	
	# Then do something to the options depending on the selection
	if option_selection == 0:
		ConnectOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 1:
		BackOption.add_color_override("font_color", hover_font_color)

func reset_opt_selection():
	option_selection = -1
	update_opt_selection()

func set_error(text: String):
	if not Error.is_visible(): Error.set_visible(true)
	Error.set_text(text)

func get_error() -> String:
	return Error.get_text()

func set_connecting(mode: bool):
	if mode:
		ConnectOption.set_process(false)
		ConnectOption.set_process_input(false)
		ConnectOption.set_text("Connecting")
	elif not mode:
		ConnectOption.set_process(true)
		ConnectOption.set_process_input(true)
		ConnectOption.set_text("Connect")
	
	is_connecting = mode

func _lobby_connection_success():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/maps/Tutorial.tscn")

func _lobby_connection_fail():
	set_connecting(false)
	set_error("Failed to join lobby.")

func _on_ServerAddress_text_changed(new_text):
	if is_connecting: ServerAddress.delete_char_at_cursor()
	ConfigWatcher.get_lobby_config().set_remote_server_address(new_text)
	ConfigWatcher.save()

func _on_ServerPort_text_changed(new_text):
	if not new_text.is_valid_integer() or is_connecting:
		ServerPort.delete_char_at_cursor()
	
	ConfigWatcher.get_lobby_config().set_remote_server_port(new_text)
	ConfigWatcher.save()

func _on_ServerAddress_focus_entered():
	is_typing = true

func _on_ServerAddress_focus_exited():
	is_typing = false

func _on_ServerPort_focus_entered():
	is_typing = true

func _on_ServerPort_focus_exited():
	is_typing = false

func _on_ConnectOption_mouse_entered():
	if option_selection == 0 or is_connecting:
		return
	
	option_selection = 0
	update_opt_selection()

func _on_BackOption_mouse_entered():
	if option_selection == 1: return
	option_selection = 1
	update_opt_selection()

func _on_ConnectOption_mouse_exited():
	if is_connecting: return
	reset_opt_selection()

func _on_BackOption_mouse_exited():
	reset_opt_selection()

func _on_ConnectOption_gui_input(event):
	if is_connecting: return
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
