extends Node

func _ready():
	# Initialize game configuration
	init_audio_config()
	init_graphics_config()
	
	# warning-ignore:return_value_discarded 
	# Delay for 1 second then change to game menu
	get_tree().change_scene("res://Scenes/DelayScene.tscn")

func init_audio_config():
	# Initialize sound based on saved configuration
	var config = ConfigWatcher.get_audio_config()
	var devices = AudioServer.get_device_list()
	var voice_devices = AudioServer.capture_get_device_list()
	
	var ingame_bus = AudioServer.get_bus_index("In-Game")
	var voice_bus = AudioServer.get_bus_index("Voice")
	
	AudioServer.set_bus_volume_db(ingame_bus,
		config.get_ingame_volume())
	AudioServer.set_bus_volume_db(voice_bus,
		config.get_voice_volume())
	
	AudioServer.set_bus_mute(ingame_bus, config.is_muted())
	AudioServer.set_bus_mute(voice_bus, config.is_muted())
	
	AudioServer.set_device(devices[config.get_device()])
	AudioServer.capture_set_device(voice_devices[config.get_voice_device()])

func init_graphics_config():
	# Initialize display based on saved configuration
	var config = ConfigWatcher.get_graphics_config()
	var size = config.get_window_size()
	var is_fullscreen = config.get_display_mode() == 0
	var is_maximized = config.is_maximized()
	
	OS.set_window_fullscreen(is_fullscreen)
	OS.set_window_maximized(is_maximized)
	
	if not is_fullscreen and not is_maximized:
		OS.set_window_size(size)
		OS.center_window()
