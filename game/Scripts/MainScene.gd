extends Node

func _ready():
	# Initialize game configuration
	init_audio_config()
	init_graphics_config()
	
	# warning-ignore:return_value_discarded 
	# Switch to main menu scene
	get_tree().change_scene("res://Scenes/Menu.tscn")

func init_audio_config():
	# Initialize sound based on saved configuration
	var config = ConfigWatcher.get_audio_config()
	var devices = AudioServer.get_device_list()
	var voice_devices = AudioServer.capture_get_device_list()
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("In-Game"),
		config.get_ingame_volume())
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"),
		config.get_voice_volume())
	
	AudioServer.set_device(devices[config.get_device()])
	AudioServer.capture_set_device(voice_devices[config.get_voice_device()])

func init_graphics_config():
	# Initialize display based on saved configuration
	var config = ConfigWatcher.get_graphics_config()
	var size = config.get_window_size()
	var is_fullscreen = config.get_display_mode() == 0
	if not is_fullscreen: OS.set_window_size(size)
	OS.set_window_fullscreen(is_fullscreen)
	OS.set_window_maximized(config.is_maximized())
