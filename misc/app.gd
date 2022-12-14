extends Node

func quit():
	# Correct way to quit the game, with notification
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
	get_tree().quit()
