extends Node

var paused = false

func _ready():
	get_tree().set_auto_accept_quit(false)
	print("Initialized Application watcher")

func _notification(what):
	match what:
		NOTIFICATION_WM_QUIT_REQUEST, NOTIFICATION_WM_GO_BACK_REQUEST:
			# Save configuration then quit
			ConfigWatcher.save()
			get_tree().quit()

func pause():
	paused = true
	get_tree().set_pause(true)

func resume():
	paused = false
	get_tree().set_pause(false)

func is_paused() -> bool:
	return paused

func quit():
	# A wrapper function for exiting the game
	if OS.get_name() == "Android":
		notification(NOTIFICATION_WM_GO_BACK_REQUEST)
		return
	
	notification(NOTIFICATION_WM_QUIT_REQUEST)
