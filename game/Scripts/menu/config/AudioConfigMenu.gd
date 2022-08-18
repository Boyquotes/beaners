extends MarginContainer

var default_font_color = Color(1, 1, 1, 1)
var hover_font_color = Color("#D3D3D3")

onready var BackOption = $"Root/MarginContents/Contents/NavigationContents/BackOption"

onready var InGameVolumeOption = $"Root/MarginContents/Contents/InGameVolumeOption"
onready var InGameVolOptLabel = $"Root/MarginContents/Contents/InGameVolumeOption/InGameVolOptLabel"
onready var InGameVolOptSlider = $"Root/MarginContents/Contents/InGameVolumeOption/InGameVolOptSlider"

onready var VoiceVolumeOption = $"Root/MarginContents/Contents/VoiceVolumeOption"
onready var VoiceVolOptLabel = $"Root/MarginContents/Contents/VoiceVolumeOption/VoiceVolOptLabel"
onready var VoiceVolOptSlider = $"Root/MarginContents/Contents/VoiceVolumeOption/VoiceVolOptSlider"

onready var DeviceOption = $"Root/MarginContents/Contents/DeviceOption"
onready var DeviceOptionLabel = $"Root/MarginContents/Contents/DeviceOption/DeviceOptionLabel"
onready var DeviceOptionMenu = $"Root/MarginContents/Contents/DeviceOption/DeviceOptionMenu"

onready var VoiceDeviceOption = $"Root/MarginContents/Contents/VoiceDeviceOption"
onready var VoiceDeviceOptLabel = $"Root/MarginContents/Contents/VoiceDeviceOption/VoiceDeviceOptLabel"
onready var VoiceDeviceOptMenu = $"Root/MarginContents/Contents/VoiceDeviceOption/VoiceDeviceOptMenu"

export var option_selection = -1

func _ready():
	# Load all I/O devices to DeviceOptionMenu and VoiceDeviceOptMenu
	for device in AudioServer.get_device_list():
		DeviceOptionMenu.add_item(device)
	for device in AudioServer.capture_get_device_list():
		VoiceDeviceOptMenu.add_item(device)
	
	# Set volume sliders and menu indexes from saved audio configuration
	InGameVolOptSlider.set_value(ConfigWatcher.get_audio_config().get_ingame_volume())
	VoiceVolOptSlider.set_value(ConfigWatcher.get_audio_config().get_voice_volume())
	DeviceOptionMenu.select(ConfigWatcher.get_audio_config().get_device())
	VoiceDeviceOptMenu.select(ConfigWatcher.get_audio_config().get_voice_device())

func _input(event):
	if event is InputEventMouseMotion:
		# Show the mouse cursor if moved
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event is InputEventKey:
		# Hide the mouse cursor if a key is pressed
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	# React to left-and-right input actions for options
	if Input.is_action_just_pressed("ui_up"):
		if option_selection > 0:
			option_selection -= 1
		elif option_selection == -1:
			option_selection = 0
		
		update_opt_selection()
	elif Input.is_action_just_pressed("ui_down"):
		if option_selection < 3:
			option_selection += 1
		
		update_opt_selection()
		
	# Call handle_opt_selection for the accept input action
	if Input.is_action_just_pressed("ui_accept"):
		handle_opt_selection()
	# Return to main menu for the cancel input action
	if Input.is_action_just_pressed("ui_cancel"):
		option_selection = 0
		handle_opt_selection()

func handle_opt_selection():
	# Handle selected option, this is used when pressing the accept input action
	UiSoundGlobals.Select.play()
	
	if option_selection == -1:
		option_selection = 1
	if option_selection == 0:
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/menu/ConfigMenu.tscn")

func update_opt_selection():
	# This function must be called after option_selection has changed
	# Reset all the options first before doing anything else
	BackOption.add_color_override("font_color", default_font_color)
	InGameVolOptLabel.add_color_override("font_color", default_font_color)
	VoiceVolOptLabel.add_color_override("font_color", default_font_color)
	DeviceOptionLabel.add_color_override("font_color", default_font_color)
	VoiceDeviceOptLabel.add_color_override("font_color", default_font_color)
	
	if option_selection != -1: UiSoundGlobals.Navigate.play()
	
	# Then do something to the options depending on the selection
	if option_selection == 0:
		BackOption.add_color_override("font_color", hover_font_color)
	elif option_selection == 1:
		InGameVolOptLabel.add_color_override("font_color",
			hover_font_color)
	elif option_selection == 2:
		VoiceVolOptLabel.add_color_override("font_color",
			hover_font_color)
	elif option_selection == 3:
		DeviceOptionLabel.add_color_override("font_color",
			hover_font_color)
	elif option_selection == 4:
		VoiceDeviceOptLabel.add_color_override("font_color",
			hover_font_color)

func reset_opt_selection():
	option_selection = -1
	update_opt_selection()

func _on_InGameVolOptSlider_drag_ended(_value_changed):
	if UiSoundGlobals.Select.is_playing():
		UiSoundGlobals.Select.stop()
	
	UiSoundGlobals.Select.play()

func _on_InGameVolOptSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("In-Game"),
		value)
	
	ConfigWatcher.get_audio_config().set_ingame_volume(value)
	ConfigWatcher.save()

func _on_VoiceVolOptSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"),
		value)
	
	ConfigWatcher.get_audio_config().set_voice_volume(value)
	ConfigWatcher.save()

func _on_DeviceOptionMenu_item_selected(index):
	ConfigWatcher.get_audio_config().set_device(index)
	ConfigWatcher.save()

func _on_VoiceDeviceOptMenu_item_selected(index):
	ConfigWatcher.get_audio_config().set_voice_device(index)
	ConfigWatcher.save()

func _on_BackOption_mouse_entered():
	if option_selection == 0: return
	option_selection = 0
	update_opt_selection()

func _on_BackOption_mouse_exited():
	reset_opt_selection()

func _on_InGameVolumeOption_mouse_entered():
	if option_selection == 1: return
	option_selection = 1
	update_opt_selection()

func _on_InGameVolumeOption_mouse_exited():
	reset_opt_selection()

func _on_VoiceVolumeOption_mouse_entered():
	if option_selection == 2: return
	option_selection = 2
	update_opt_selection()

func _on_VoiceVolumeOption_mouse_exited():
	reset_opt_selection()

func _on_DeviceOption_mouse_entered():
	if option_selection == 3: return
	option_selection = 3
	update_opt_selection()

func _on_DeviceOption_mouse_exited():
	reset_opt_selection()

func _on_VoiceDeviceOption_mouse_entered():
	if option_selection == 4: return
	option_selection = 4
	update_opt_selection()

func _on_VoiceDeviceOption_mouse_exited():
	reset_opt_selection()

func _on_BackOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 0
		handle_opt_selection()

func _on_InGameVolumeOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 1
		handle_opt_selection()

func _on_VoiceVolumeOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 2
		handle_opt_selection()

func _on_DeviceOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 3
		handle_opt_selection()

func _on_VoiceDeviceOption_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		handle_opt_selection()
	if event is InputEventScreenTouch and event.is_pressed():
		option_selection = 4
		handle_opt_selection()
