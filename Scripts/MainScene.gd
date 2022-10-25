extends Node

func _ready():
	# Initialize game configuration
	init_audio_config()
	init_video_config()
	
	# warning-ignore:return_value_discarded 
	# Delay for 1 second then change to game menu
	get_tree().change_scene("res://Scenes/DelayScene.tscn")

func init_audio_config():
	# Initialize sound from saved configuration
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

func init_video_config():
	# Initialize video from saved configuration
	var config = ConfigWatcher.get_video_config()
	var scale = config.get_ui_scale() if OS.get_name() != "Android" else 1.0
	var min_size = config.get_minimum_window_size()
	var max_size = config.get_maximum_window_size()
	var size = config.get_window_size()
	var is_fullscreen = config.get_display_mode() == 1
	var is_maximized = config.is_window_maximized()
	var is_vsync_enabled = config.is_display_vsync_enabled()
	
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,
		SceneTree.STRETCH_ASPECT_EXPAND, size, scale)
	
	OS.set_min_window_size(min_size)
	OS.set_max_window_size(max_size)
	OS.set_use_vsync(is_vsync_enabled)
	OS.set_window_fullscreen(is_fullscreen)
	OS.set_window_maximized(is_maximized)
	
	if not is_fullscreen and not is_maximized:
		OS.set_window_size(size)
		OS.center_window()
