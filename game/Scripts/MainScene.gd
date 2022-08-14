extends Node

func _ready():
	# Initialize game configuration
	init_audio_config()
	init_graphics_config()
	
	# warning-ignore:return_value_discarded 
	# Switch to main menu scene
	get_tree().change_scene("res://Scenes/menu/MainMenu.tscn")

func init_audio_config():
	# Initialize sound based on saved configuration
	var config = ConfigWatcher.get_audio_config()
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("In-Game"),
		config.get_ingame_volume())
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"),
		config.get_voice_volume())
	
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),
		config.is_muted())
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("In-Game"),
		config.is_muted())
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"),
		config.is_muted())

func init_graphics_config():
	# Initialize display based on saved configuration
	var config = ConfigWatcher.get_graphics_config()
	var size = config.get_window_size()
	var is_fullscreen = config.get_display_mode() == 0
	OS.set_window_fullscreen(is_fullscreen)
	OS.set_window_maximized(config.is_maximized())
	
	if not is_fullscreen:
		OS.set_window_size(size)
	else:
		get_viewport().set_size(size)
