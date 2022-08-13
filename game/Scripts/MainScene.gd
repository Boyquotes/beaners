extends Node

func _ready():
	# Initialize configuration
	init_default_config()
	init_audio_config()
	init_display_config()
	
	# warning-ignore:return_value_discarded 
	# Switch to main menu scene
	get_tree().change_scene("res://Scenes/menu/MainMenu.tscn")

func _window_resized():
	# This function is called when root's size_changed is emitted
	# and will save the unsaved window size changes
	var config = ConfigFile.new()
	
	if config.load("user://game.cfg") != OK: return
	if OS.is_window_fullscreen(): return # Fullscreen isn't allowed
	config.set_value("Graphics", "width", OS.get_window_size().x)
	config.set_value("Graphics", "height", OS.get_window_size().y)
	config.save("user://game.cfg")

func init_audio_config():
	# Initialize sound based on saved configuration
	var config = ConfigFile.new()
	
	if config.load("user://game.cfg") != OK:
		print("Failed to initialize sound configuration")
		return
	
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("In-Game"),
		config.get_value("Audio", "in-game-volume"))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"),
		config.get_value("Audio", "voice-volume"))
	
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"),
		config.get_value("Audio", "mute"))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("In-Game"),
		config.get_value("Audio", "mute"))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Voice"),
		config.get_value("Audio", "mute"))

func init_display_config():
	# Initialize display based on saved configuration
	var config = ConfigFile.new()
	
	if config.load("user://game.cfg") != OK:
		print("Failed to initialize display configuration")
		return
	if config.get_value("Graphics", "fullscreen"):
		# NOTE: Changing resolution in fullscreen is not possible yet in Godot
		OS.set_window_fullscreen(true)
	else:
		OS.set_window_size(Vector2(config.get_value("Graphics", "width"),
		config.get_value("Graphics", "height")))

func init_default_config():
	# Initialize default config if first-run
	var config = ConfigFile.new()
	var file = "user://game.cfg"
	
	if config.load(file) == OK: return # This means that game.cfg exists
	
	# Set default configuration for the player and lobby
	config.set_value("Player", "name", "Player-" + String(OS.get_process_id()))
	config.set_value("Lobby", "host-player-limit", 10)
	config.set_value("Lobby", "host-map-selection", 3)
	
	# Also for sound and display values
	config.set_value("Audio", "in-game-volume", 80.0)
	config.set_value("Audio", "voice-volume", 30.0)
	config.set_value("Audio", "mute", false)
	config.set_value("Graphics", "shadows", true)
	config.set_value("Graphics", "fullscreen", false)
	config.set_value("Graphics", "width", 1024.0)
	config.set_value("Graphics", "height", 600.0)
	config.set_value("Graphics", "renderer", null)
	
	# Then finally save the default configuration
	var failure_save_err = "There was an error during default initialization"
	if config.save(file) != OK: print(failure_save_err)
