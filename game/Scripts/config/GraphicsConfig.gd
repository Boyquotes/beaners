extends Node

var cfg = ConfigFile.new()

const DISPLAY_MODE = "display-mode"
const RENDERER = "renderer"
const MAXIMIZE = "maximize"
const SHADOWS = "shadows"
const WINDOW_HEIGHT = "window-height"
const WINDOW_WIDTH = "window-width"

enum DisplayMode {
	Fullscreen, Windowed, Borderless
}

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

func set_display_mode(mode: int):
	set_value(DISPLAY_MODE, mode)

func get_display_mode(default = DisplayMode.Windowed) -> int:
	return get_value(DISPLAY_MODE, default)

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

func set_window_size(value: Vector2):
	set_value(WINDOW_WIDTH, value.x)
	set_value(WINDOW_HEIGHT, value.y)

func get_window_size(default = Vector2(1024.0, 600.0)) -> Vector2:
	return Vector2(get_value(WINDOW_WIDTH, default.x),
			get_value(WINDOW_HEIGHT, default.y))

func set_value(key, value):
	get_cfg().set_value("Graphics", key, value)

func get_value(key, default = null):
	return get_cfg().get_value("Graphics", key, default)
