extends Node

const CONFIG_PATH = "user://game.cfg"
const SETTINGS_PATH = "user://settings.godot"

func _ready():
	get_tree().set_auto_accept_quit(false)
	print("Initialized Application watcher")

func _notification(what):
	match what:
		NOTIFICATION_WM_QUIT_REQUEST, NOTIFICATION_WM_GO_BACK_REQUEST:
			# Save configuration then quit
			ConfigWatcher.save()
			get_tree().quit()

func quit():
	# A wrapper function for exiting the game
	if OS.get_name() == "Android":
		notification(NOTIFICATION_WM_GO_BACK_REQUEST)
		return
	
	notification(NOTIFICATION_WM_QUIT_REQUEST)
