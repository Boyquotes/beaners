extends Node

var cfg = ConfigFile.new()

const INGAME_VOLUME = "ingame-volume"
const VOICE_VOLUME = "voice-volume"
const DEVICE = "device"
const VOICE_DEVICE = "microphone-device"

func init(path: String) -> int:
	var err = get_cfg().load(path)
	
	for section in get_cfg().get_sections():
		if section == "Audio": continue
		get_cfg().erase_section(section)
	
	return err

func set_cfg(new_cfg: ConfigFile):
	cfg = new_cfg

func get_cfg() -> ConfigFile:
	return cfg

func set_ingame_volume(db: float):
	set_value(INGAME_VOLUME, db)

func get_ingame_volume(default = 8.0) -> float:
	return get_value(INGAME_VOLUME, default)

func set_voice_volume(db: float):
	set_value(VOICE_VOLUME, db)

func get_voice_volume(default = 5.0) -> float:
	return get_value(VOICE_VOLUME, default)

func set_device(index: int):
	set_value(DEVICE, index)

func get_device(default = 0) -> int:
	return get_value(DEVICE, default)

func set_voice_device(index: int):
	set_value(VOICE_DEVICE, index)

func get_voice_device(default = 0) -> int:
	return get_value(VOICE_DEVICE, default)

func set_value(key, value):
	get_cfg().set_value("Audio", key, value)

func get_value(key, default = null):
	return get_cfg().get_value("Audio", key, default)
