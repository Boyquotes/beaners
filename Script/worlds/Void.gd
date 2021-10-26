extends Spatial

onready var lighting = $"Lighting"
onready var debug_overlay_label = $"DebugOverlay/Label"

var config = ConfigFile.new()

func _ready():
	if not OS.is_debug_build():
		debug_overlay_label.hide()

func _process(_delta):
	config.load("user://settings.cfg")
	
	if config.has_section_key("Graphics", "Shadows") and config.get_value("Graphics", "Shadows") == true:
		lighting.set_shadow(true)
	elif not config.has_section_key("Graphics", "Shadows") or config.get_value("Graphics", "Shadows") == false:
		lighting.set_shadow(false)
	if Input.is_action_pressed("ui_debug"):
		if not debug_overlay_label.is_visible():
			debug_overlay_label.set_visible(true)
		else:
			debug_overlay_label.set_visible(false)
