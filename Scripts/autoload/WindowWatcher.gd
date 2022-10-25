extends Node

func _ready():
	# Attach _size_changed to root's size_changed signal
	# warning-ignore:return_value_discarded
	get_tree().get_root().connect("size_changed", self, "_size_changed")

func _size_changed():
	# This function is called when root's size_changed is emitted
	# It saves the current window properties to the settings file
	ProjectSettings.set_setting("display/window/size/width",
		OS.get_window_size()[0])
	ProjectSettings.set_setting("display/window/size/height",
		OS.get_window_size()[1])
	ProjectSettings.set_setting("display/window/size/borderless",
		OS.get_borderless_window())
	ProjectSettings.set_setting("display/window/size/fullscreen",
		OS.is_window_fullscreen())
	
	# Delay saving window properties to game settings
	yield(get_tree().create_timer(1), "timeout")
	# warning-ignore:return_value_discarded
	ProjectSettings.save_custom(AppWatcher.SETTINGS_PATH)
