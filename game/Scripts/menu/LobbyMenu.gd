extends MarginContainer

var default_font_color = Color(1, 1, 1, 1)
var hover_font_color = Color("#D3D3D3")

var is_typing = false

onready var JoinOption = $"Root/MarginContents/Contents/JoinOption"
onready var HostOption = $"Root/MarginContents/Contents/HostOption"
onready var BackOption = $"Root/MarginContents/Contents/BackOption"
onready var PlayerName = $"Root/MarginContents/Contents/PlayerName"
onready var UiInaccessiblePlayer = $"UiInaccessiblePlayer"
onready var UiNavigatePlayer = $"UiNavigatePlayer"
onready var UiSelectPlayer = $"UiSelectPlayer"

export var option_selection = -1

func _ready():
	# Set player name from saved configuration
	PlayerName.set_text(ConfigWatcher.get_player_config().get_player_name())

func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		# Release edit focus for PlayerName when background is touched or pressed
		if event.is_pressed():
			PlayerName.release_focus()
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
		option_selection = 2
		handle_opt_selection()

func handle_opt_selection():
	# Handle selected option, this is used when pressing the accept input action
	if UiNavigatePlayer.is_playing():
		UiNavigatePlayer.stop()
	
	if option_selection != 2:
		if PlayerName.get_text().length() < 1:
			# Put your name first before proceeding to join/create lobbies
			if UiInaccessiblePlayer.is_playing():
				UiInaccessiblePlayer.stop()
			
			UiInaccessiblePlayer.play()
			return
		
		UiSelectPlayer.play()
	else:
		UiInaccessiblePlayer.play()
	
	if option_selection == -1:
		option_selection = 0
	if option_selection == 0:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/menu/lobby/LobbyJoinMenu.tscn")
	elif option_selection == 1:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/menu/lobby/LobbyHostMenu.tscn")
	elif option_selection == 2:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/menu/MainMenu.tscn")

func update_opt_selection():
	# This function must be called after option_selection has changed
	# Reset all the options first before doing anything else
	JoinOption.add_color_override("font_color", default_font_color)
	HostOption.add_color_override("font_color", default_font_color)
	BackOption.add_color_override("font_color", default_font_color)
	
	if option_selection != -1: UiNavigatePlayer.play()
	
	# Then do something to the options depending on the selection
	if option_selection == 0:
		JoinOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 1:
		HostOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 2:
		BackOption.add_color_override("font_color", hover_font_color)

func reset_opt_selection():
	option_selection = -1
	update_opt_selection()

func _on_PlayerName_text_changed(new_text):
	if new_text.length() < 1:
		var default_name = "Player-" + String(OS.get_process_id())
		PlayerName.set_text(default_name)
		PlayerName.emit_signal("text_changed", default_name)
		return
	
	ConfigWatcher.get_player_config().set_player_name(new_text)
	ConfigWatcher.save()

func _on_JoinOption_mouse_entered():
	if option_selection == 0: return
	option_selection = 0
	update_opt_selection()

func _on_HostOption_mouse_entered():
	if option_selection == 1: return
	option_selection = 1
	update_opt_selection()

func _on_BackOption_mouse_entered():
	if option_selection == 2: return
	option_selection = 2
	update_opt_selection()

func _on_JoinOption_mouse_exited():
	reset_opt_selection()

func _on_HostOption_mouse_exited():
	reset_opt_selection()

func _on_BackOption_mouse_exited():
	reset_opt_selection()

func _on_JoinOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 0
		handle_opt_selection()

func _on_HostOption_gui_input(event):
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

func _on_PlayerName_focus_entered():
	is_typing = true

func _on_PlayerName_focus_exited():
	is_typing = false
