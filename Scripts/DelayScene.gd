extends MarginContainer

func _ready():
	yield(get_tree().create_timer(3.0), "timeout")
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Menu.tscn")
