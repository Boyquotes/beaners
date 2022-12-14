extends Spatial

func _ready():
	if not Interface.has_shown_startup:
		var _s = get_tree().change_scene("res://misc/startup.tscn")
	
	# Show main menu if not visible
	add_child(load("res://misc/menu.tscn").instance())
