extends Node

func _ready():
	# Attach _window_resized to root's size_changed signal
	# warning-ignore:return_value_discarded
	get_tree().get_root().connect("size_changed", self, "_window_resized")

func _window_resized():
	# This function is called when root's size_changed is emitted
	# and will save the unsaved window size changes
	var config = ConfigFile.new()
	
	if config.load("user://game.cfg") != OK: return
	if OS.is_window_fullscreen(): return # Fullscreen isn't allowed
	config.set_value("Graphics", "width", OS.get_window_size().x)
	config.set_value("Graphics", "height", OS.get_window_size().y)
	config.save("user://game.cfg")
