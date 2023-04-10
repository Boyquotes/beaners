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
	var config = ConfigWatcher.get_video_config()
	var scale = config.get_ui_scale()
	var root = get_tree().get_root()
	
	config.set_window_maximize(OS.is_window_maximized())
	config.set_window_size(root.get_size())
	
	# Also update the UI scale
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,
		SceneTree.STRETCH_ASPECT_EXPAND, root.get_size(), scale)
