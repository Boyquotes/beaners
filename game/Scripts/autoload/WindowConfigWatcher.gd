extends Node

func _init():
	print("Initialized Window configuration watcher")

func _ready():
	# Attach _window_resized to root's size_changed signal
	# warning-ignore:return_value_discarded
	get_tree().get_root().connect("size_changed", self, "_window_resized")

func _window_resized():
	# This function is called when root's size_changed is emitted
	# and will save the unsaved window size changes
	var config = ConfigWatcher.get_graphics_config()
	
	if OS.is_window_fullscreen(): return # Fullscreen isn't allowed
	config.set_width(OS.get_window_size().x)
	config.set_height(OS.get_window_size().y)
	ConfigWatcher.save()
