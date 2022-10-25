extends Node

const PATH_CONFIG = AppWatcher.CONFIG_PATH

# These constants were used in an old way to retrieve/save
# video and audio configuration to the filesystem.
# const SCRIPT_AUDIO_CONFIG = "res://Scripts/config/AudioConfig.gd"
# const SCRIPT_VIDEO_CONFIG = "res://Scripts/config/VideoConfig.gd"

const SCRIPT_LOBBY_CONFIG = "res://Scripts/config/LobbyConfig.gd"
const SCRIPT_PLAYER_CONFIG = "res://Scripts/config/PlayerConfig.gd"

onready var lobby_config = preload(SCRIPT_LOBBY_CONFIG).new()
onready var player_config = preload(SCRIPT_PLAYER_CONFIG).new()

func _ready():
	init()

func init():
	# Initialize failsafe variables
	var is_lobby_failed = false
	var is_player_failed = false
	
	# Initialize configurations
	if get_lobby_config().init(PATH_CONFIG) == OK:
		print("Initialized Lobby configuration")
	else:
		is_lobby_failed = true
		printerr("Failed to init Lobby configuration")
	if get_player_config().init(PATH_CONFIG) == OK:
		print("Initialized Player configuration")
	else:
		is_player_failed = true
		printerr("Failed to init Player configuration")
	if is_lobby_failed and is_player_failed:
		print("Received errors while reading configurations.")
		print("This is normal if you are running the game for the first-time.")

func save():
	# Save configurations
	var config = ConfigFile.new()
	var lobby_cfg = get_lobby_config().get_cfg()
	var player_cfg = get_player_config().get_cfg()
	
	for section in lobby_cfg.get_sections():
		for key in lobby_cfg.get_section_keys(section):
			var value = lobby_cfg.get_value(section, key)
			config.set_value(section, key, value)
	for section in player_cfg.get_sections():
		for key in player_cfg.get_section_keys(section):
			var value = player_cfg.get_value(section, key)
			config.set_value(section, key, value)
	
	if config.save(PATH_CONFIG) != OK:
		printerr("Unable to save game configuration")

func get_lobby_config():
	return lobby_config

func get_player_config():
	return player_config
