extends Node

const PATH_CONFIG = "user://game.cfg"

const SCRIPT_AUDIO_CONFIG = "res://Scripts/config/AudioConfig.gd"
const SCRIPT_VIDEO_CONFIG = "res://Scripts/config/VideoConfig.gd"
const SCRIPT_LOBBY_CONFIG = "res://Scripts/config/LobbyConfig.gd"
const SCRIPT_PLAYER_CONFIG = "res://Scripts/config/PlayerConfig.gd"

onready var audio_config = preload(SCRIPT_AUDIO_CONFIG).new()
onready var video_config = preload(SCRIPT_VIDEO_CONFIG).new()
onready var lobby_config = preload(SCRIPT_LOBBY_CONFIG).new()
onready var player_config = preload(SCRIPT_PLAYER_CONFIG).new()

func _init():
	print("Initialized Configuration watcher")

func _ready():
	init()

func init():
	# Initialize failsafe variables
	var is_audio_failed = false
	var is_video_failed = false
	var is_lobby_failed = false
	var is_player_failed = false
	
	# Initialize configurations
	if get_audio_config().init(PATH_CONFIG) == OK:
		print("Initialized Audio configuration watcher")
	else:
		is_audio_failed = true
		printerr("Failed to init Audio configuration watcher")
	if get_video_config().init(PATH_CONFIG) == OK:
		print("Initialized Video configuration watcher")
	else:
		is_video_failed = true
		printerr("Failed to init Video configuration watcher")
	if get_lobby_config().init(PATH_CONFIG) == OK:
		print("Initialized Lobby configuration watcher")
	else:
		is_lobby_failed = true
		printerr("Failed to init Lobby configuration watcher")
	if get_player_config().init(PATH_CONFIG) == OK:
		print("Initialized Player configuration watcher")
	else:
		is_player_failed = true
		printerr("Failed to init Player configuration watcher")
	if is_audio_failed and is_video_failed and is_lobby_failed and is_player_failed:
		print("Received errors while reading configurations.")
		print("This is normal if you are running the game for the first-time.")

func save():
	# Save configurations
	var config = ConfigFile.new()
	
	var audio_cfg = get_audio_config().get_cfg()
	var video_cfg = get_video_config().get_cfg()
	var lobby_cfg = get_lobby_config().get_cfg()
	var player_cfg = get_player_config().get_cfg()
	
	for section in audio_cfg.get_sections():
		for key in audio_cfg.get_section_keys(section):
			var value = audio_cfg.get_value(section, key)
			config.set_value(section, key, value)
	for section in video_cfg.get_sections():
		for key in video_cfg.get_section_keys(section):
			var value = video_cfg.get_value(section, key)
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

func get_video_config():
	return video_config

func get_lobby_config():
	return lobby_config

func get_player_config():
	return player_config
