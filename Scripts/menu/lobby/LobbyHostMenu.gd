extends MarginContainer

var default_font_color = Color(1, 1, 1, 1)
var hover_font_color = Color("#D3D3D3")

var is_typing = false

onready var ServerPort = $"Root/Contents/ServerPort"
onready var PlayerLimit = $"Root/Contents/PlayerLimitContent/PlayerLimit"
onready var PlayerLimitCount = $"Root/Contents/PlayerLimitContent/PlayerLimitCount"
onready var MapSelection = $"Root/Contents/MapSelectionContent/MapSelection"
onready var Error = $"Root/Contents/Error"
onready var StartOption = $"Root/Contents/OptionsContent/StartOption"
onready var BackOption = $"Root/Contents/OptionsContent/BackOption"

export var option_selection = -1

func _ready():
	# Set map selection, player limit, and port from saved configuration
	ServerPort.set_text(ConfigWatcher.get_lobby_config().get_host_server_port())
	PlayerLimit.set_value(ConfigWatcher.get_lobby_config().get_host_player_limit())
	MapSelection.select(ConfigWatcher.get_lobby_config().get_host_map_selection())

func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		# Release edit focus for PlayerName when background is touched or pressed
		if event.is_pressed():
			ServerPort.release_focus()
			PlayerLimit.release_focus()
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
	UiSoundGlobals.Select.play()
	
	if option_selection == -1:
		option_selection = 0
	if option_selection == 0:
		var peer = NetworkedMultiplayerENet.new()
		var player_limit = int(PlayerLimit.get_value())
		
		var err = peer.create_server(int(ServerPort.get_text()),
			player_limit if player_limit > 0 else 4095)
		
		if err == OK:
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://Scenes/Map.tscn")
			get_tree().set_network_peer(peer)
		elif err == ERR_CANT_CREATE:
			UiSoundGlobals.Inaccessible.play()
			set_error("Cannot create lobby.")
		elif err == ERR_ALREADY_IN_USE:
			UiSoundGlobals.Inaccessible.play()
			set_error("Lobby currently in-use.")
	elif option_selection == 1:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/menu/LobbyMenu.tscn")

func update_opt_selection():
	# This function must be called after option_selection has changed
	# Reset all the options first before doing anything else
	StartOption.add_color_override("font_color", default_font_color)
	BackOption.add_color_override("font_color", default_font_color)
	
	if option_selection != -1: UiSoundGlobals.Navigate.play()
	
	# Then do something to the options depending on the selection
	if option_selection == 0:
		StartOption.add_color_override("font_color", hover_font_color)
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

func _on_ServerPort_text_changed(new_text):
	if not new_text.is_valid_integer():
		ServerPort.delete_char_at_cursor()
	
	var config = ConfigWatcher.get_lobby_config()
	config.set_host_server_port(new_text)

func _on_PlayerLimit_value_changed(value):
	PlayerLimitCount.set_text(String(value))
	if value > 30: PlayerLimitCount.set_text("∞")
	ConfigWatcher.get_lobby_config().set_host_player_limit(value)

func _on_MapSelection_item_selected(index):
	var config = ConfigWatcher.get_lobby_config()
	config.set_host_map_selection(index)

func _on_ServerAddress_focus_entered():
	is_typing = true

func _on_ServerAddress_focus_exited():
	is_typing = false

func _on_ServerPort_focus_entered():
	is_typing = true

func _on_ServerPort_focus_exited():
	is_typing = false

func _on_PlayerLimit_focus_entered():
	is_typing = true

func _on_PlayerLimit_focus_exited():
	is_typing = false

func _on_StartOption_mouse_entered():
	if option_selection == 0: return
	option_selection = 0
	update_opt_selection()

func _on_BackOption_mouse_entered():
	if option_selection == 1: return
	option_selection = 1
	update_opt_selection()

func _on_StartOption_mouse_exited():
	reset_opt_selection()

func _on_BackOption_mouse_exited():
	reset_opt_selection()

func _on_StartOption_gui_input(event):
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
