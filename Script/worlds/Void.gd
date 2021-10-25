extends Spatial

onready var debug_overlay_label = $"DebugOverlay/Label"

func _ready():
	if not OS.is_debug_build():
		debug_overlay_label.hide()

func _process(_delta):
	if Input.is_action_pressed("ui_debug"):
		if not debug_overlay_label.is_visible():
			debug_overlay_label.show()
		else:
			debug_overlay_label.hide()
