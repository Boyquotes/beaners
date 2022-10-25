extends Node

func _ready():
	# warning-ignore:return_value_discarded 
	# Delay for 1 second then change to game menu
	get_tree().change_scene("res://Scenes/DelayScene.tscn")
