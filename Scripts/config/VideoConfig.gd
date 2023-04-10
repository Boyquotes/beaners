extends Node

var cfg = ConfigFile.new()

const DISPLAY_MODE = "display-mode"
const DISPLAY_VSYNC = "display-vsync"
const GRAPHICS_RENDERER = "graphics-renderer"
const SHADOW_QUALITY = "shadow-quality"
const TEXTURE_QUALITY = "texture-quality"
const UI_SCALE = "ui-scale"
const WINDOW_MIN_WIDTH = "window-min-width"
const WINDOW_MIN_HEIGHT = "window-min-height"
const WINDOW_MAX_WIDTH = "window-max-width"
const WINDOW_MAX_HEIGHT = "window-max-height"
const WINDOW_HEIGHT = "window-height"
const WINDOW_WIDTH = "window-width"
const WINDOW_MAXIMIZE = "window-maximize"

enum DisplayMode {
	Windowed, Fullscreen, Borderless
}

enum GraphicsRenderer {
	OpenGL, Vulkan
}

enum ShadowQuality {
	Off, Low, Medium, High
}

enum TextureQuality {
	Low, Medium, High
}

func init(path: String) -> int:
	var err = get_cfg().load(path)
	
	for section in get_cfg().get_sections():
		if section == "Video": continue
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

func set_display_vsync(toggle: bool):
	set_value(DISPLAY_VSYNC, toggle)

func is_display_vsync_enabled(default = true) -> bool:
	return get_value(DISPLAY_VSYNC, default)

func set_graphics_renderer(api):
	set_value(GRAPHICS_RENDERER, api)

func get_renderer(default = GraphicsRenderer.OpenGL) -> int:
	return get_value(GRAPHICS_RENDERER, default)

func set_shadow_quality(quality):
	set_value(SHADOW_QUALITY, quality)

func get_shadow_quality(default = ShadowQuality.Medium) -> int:
	return get_value(SHADOW_QUALITY, default)

func set_texture_quality(quality):
	set_value(TEXTURE_QUALITY, quality)

func get_texture_quality(default = TextureQuality.High) -> int:
	return get_value(TEXTURE_QUALITY, default)

func set_ui_scale(value: float):
	set_value(UI_SCALE, value)

func get_ui_scale(default = 0.8) -> float:
	return get_value(UI_SCALE, default)

func set_minimum_window_size(value: Vector2):
	set_value(WINDOW_MIN_WIDTH, value.x)
	set_value(WINDOW_MIN_HEIGHT, value.y)

func get_minimum_window_size(default = Vector2(640, 480)) -> Vector2:
	return Vector2(get_value(WINDOW_MIN_WIDTH, default.x),
		get_value(WINDOW_MIN_HEIGHT, default.y))

func set_maximum_window_size(value: Vector2):
	set_value(WINDOW_MIN_WIDTH, value.x)
	set_value(WINDOW_MIN_HEIGHT, value.y)

func get_maximum_window_size(default = Vector2(0, 0)) -> Vector2:
	return Vector2(get_value(WINDOW_MAX_WIDTH, default.x),
		get_value(WINDOW_MAX_HEIGHT, default.y))

func set_window_size(value: Vector2):
	set_value(WINDOW_WIDTH, value.x)
	set_value(WINDOW_HEIGHT, value.y)

func get_window_size(default = Vector2(1024.0, 600.0)) -> Vector2:
	return Vector2(get_value(WINDOW_WIDTH, default.x),
		get_value(WINDOW_HEIGHT, default.y))

func set_window_maximize(toggle: bool):
	set_value(WINDOW_MAXIMIZE, toggle)

func is_window_maximized(default = false) -> bool:
	return get_value(WINDOW_MAXIMIZE, default)

func set_value(key, value):
	get_cfg().set_value("Video", key, value)

func get_value(key, default = null):
	return get_cfg().get_value("Video", key, default)
