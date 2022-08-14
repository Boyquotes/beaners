extends Node

const PATH_CONFIG = "user://game.cfg"

const SCRIPT_AUDIO_CONFIG = "res://Scripts/config/AudioConfig.gd"
const SCRIPT_GRAPHICS_CONFIG = "res://Scripts/config/GraphicsConfig.gd"
const SCRIPT_LOBBY_CONFIG = "res://Scripts/config/LobbyConfig.gd"
const SCRIPT_PLAYER_CONFIG = "res://Scripts/config/PlayerConfig.gd"

onready var audio_config = preload(SCRIPT_AUDIO_CONFIG).new()
onready var graphics_config = preload(SCRIPT_GRAPHICS_CONFIG).new()
onready var lobby_config = preload(SCRIPT_LOBBY_CONFIG).new()
onready var player_config = preload(SCRIPT_PLAYER_CONFIG).new()

func _init():
	print("Initialized Configuration watcher")

func _ready():
	init()

func init():
	# Initialize configurations
	if get_audio_config().init(PATH_CONFIG) == OK:
		print("Initialized Audio configuration watcher")
	else:
		printerr("Failed to init Audio configuration watcher")
	if get_graphics_config().init(PATH_CONFIG) == OK:
		print("Initialized Display configuration watcher")
	else:
		printerr("Failed to init Display configuration watcher")
	if get_lobby_config().init(PATH_CONFIG) == OK:
		print("Initialized Lobby configuration watcher")
	else:
		printerr("Failed to init Lobby configuration watcher")
	if get_player_config().init(PATH_CONFIG) == OK:
		print("Initialized Player configuration watcher")
	else:
		printerr("Failed to init Player configuration watcher")

func save():
	# Save configurations
	var config = ConfigFile.new()
	
	var audio_cfg = get_audio_config().get_cfg()
	var graphics_cfg = get_graphics_config().get_cfg()
	var lobby_cfg = get_lobby_config().get_cfg()
	var player_cfg = get_player_config().get_cfg()
	
	for section in audio_cfg.get_sections():
		for key in audio_cfg.get_section_keys(section):
			var value = audio_cfg.get_value(section, key)
			config.set_value(section, key, value)
	for section in graphics_cfg.get_sections():
		for key in graphics_cfg.get_section_keys(section):
			var value = graphics_cfg.get_value(section, key)
			config.set_value(section, key, value)
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

func get_audio_config():
	return audio_config

func get_graphics_config():
	return graphics_config

func get_lobby_config():
	return lobby_config

func get_player_config():
	return player_config
