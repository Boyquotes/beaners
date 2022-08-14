extends Node

var cfg = ConfigFile.new()

const FULLSCREEN = "fullscreen"
const HEIGHT = "height"
const MAXIMIZE = "maximize"
const RENDERER = "renderer"
const SHADOWS = "shadows"
const WIDTH = "width"

func init(path: String) -> int:
	var err = get_cfg().load(path)
	
	for section in get_cfg().get_sections():
		if section == "Graphics": continue
		get_cfg().erase_section(section)
	
	return err

func set_cfg(new_cfg: ConfigFile):
	cfg = new_cfg

func get_cfg() -> ConfigFile:
	return cfg

func set_fullscreen(toggle: bool):
	set_value(FULLSCREEN, toggle)

func is_fullscreen(default = false) -> bool:
	return get_value(FULLSCREEN, default)

func set_height(value: float):
	set_value(HEIGHT, value)

func get_height(default = 600.0) -> float:
	return get_value(HEIGHT, default)

func set_maximize(toggle: bool):
	set_value(MAXIMIZE, toggle)

func is_maximized(default = false) -> bool:
	return get_value(MAXIMIZE, default)

func set_renderer(api = null):
	set_value(RENDERER, api)

func get_renderer(default = null) -> float:
	return get_value(RENDERER, default)

func set_shadows(toggle: bool):
	set_value(SHADOWS, toggle)

func are_shadows_enabled(default = true) -> bool:
	return get_value(SHADOWS, default)

func set_width(value: float):
	set_value(WIDTH, value)

func get_width(default = 1024.0) -> float:
	return get_value(WIDTH, default)

func set_value(key, value):
	get_cfg().set_value("Graphics", key, value)

func get_value(key, default = null):
	return get_cfg().get_value("Graphics", key, default)
