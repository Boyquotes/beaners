extends Node

func _init():
	print("Initialized Window watcher")

func _ready():
	# Attach _size_changed to root's size_changed signal
	# warning-ignore:return_value_discarded
	get_tree().get_root().connect("size_changed", self, "_size_changed")

func _size_changed():
	# This function is called when root's size_changed is emitted
	# and will save the modified window size
	var config = ConfigWatcher.get_graphics_config()
	var root = get_tree().get_root()
	config.set_maximize(OS.is_window_maximized())
	config.set_window_size(root.get_size())
	ConfigWatcher.save()
