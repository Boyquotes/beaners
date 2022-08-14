extends Node

var cfg = ConfigFile.new()

const NAME = "name"

func init(path: String) -> int:
	var err = get_cfg().load(path)
	
	for section in get_cfg().get_sections():
		if section == "Player": continue
		get_cfg().erase_section(section)
	
	return err

func set_cfg(new_cfg: ConfigFile):
	cfg = new_cfg

func get_cfg() -> ConfigFile:
	return cfg

func set_player_name(value: String):
	set_value(NAME, value)

# Godot is an idiot so it identifies it as Node's get_name function
func get_player_name(default = "Player-" + String(OS.get_process_id())) -> float:
	return get_value(NAME, default)

func set_value(key, value):
	get_cfg().set_value("Player", key, value)

func get_value(key, default = null):
	return get_cfg().get_value("Player", key, default)
