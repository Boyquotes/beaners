extends Node

var cfg = ConfigFile.new()

const HOST_SERVER_ADDRESS = "host-server-address"
const HOST_SERVER_PORT = "host-server-port"
const HOST_PLAYER_LIMIT = "host-player-limit"
const HOST_MAP_SELECTION = "host-map-selection"
const REMOTE_SERVER_ADDRESS = "remote-server-address"
const REMOTE_SERVER_PORT = "remote-server-port"

func init(path: String) -> int:
	var err = get_cfg().load(path)
	
	for section in get_cfg().get_sections():
		if section == "Lobby": continue
		get_cfg().erase_section(section)
	
	return err

func set_cfg(new_cfg: ConfigFile):
	cfg = new_cfg

func get_cfg() -> ConfigFile:
	return cfg

func set_host_server_address(value: String):
	set_value(HOST_SERVER_ADDRESS, value)

func get_host_server_address(default = ""):
	return get_value(HOST_SERVER_ADDRESS, default)

func set_host_server_port(value: String):
	set_value(HOST_SERVER_PORT, value)

func get_host_server_port(default = ""):
	return get_value(HOST_SERVER_PORT, default)

func set_host_player_limit(value: int):
	set_value(HOST_PLAYER_LIMIT, value)

func get_host_player_limit(default = 10):
	return get_value(HOST_PLAYER_LIMIT, default)

func set_host_map_selection(value: int):
	set_value(HOST_MAP_SELECTION, value)

func get_host_map_selection(default = 3):
	return get_value(HOST_MAP_SELECTION, default)

func set_remote_server_address(value: String):
	set_value(REMOTE_SERVER_ADDRESS, value)

func get_remote_server_address(default = ""):
	return get_value(REMOTE_SERVER_ADDRESS, default)

func set_remote_server_port(default = ""):
	return get_value(REMOTE_SERVER_PORT, default)

func get_remote_server_port(default = ""):
	return get_value(REMOTE_SERVER_PORT, default)

func set_value(key, value):
	get_cfg().set_value("Lobby", key, value)

func get_value(key, default = null):
	return get_cfg().get_value("Lobby", key, default)
