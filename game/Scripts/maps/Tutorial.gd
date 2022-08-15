extends Spatial

onready var Logs = $"Logs"
onready var Players = $"Players"

func _ready():
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_peer_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_peer_disconnected")
	create_player(get_tree().get_network_unique_id())

func create_player(id: int):
	var player = preload("res://Scenes/Player.tscn").instance()
	player.set_name(String(id))
	player.set_network_master(id)
	Players.add_child(player)

func destroy_player(id: int):
	var player = Players.get_node(String(id))
	Players.remove_child(player)
	player.queue_free()

func _peer_connected(id):
	if id > 1:
		for player in Players.get_children():
			Logs.msg(String(id) + " has joined!")
	
	create_player(id)

func _peer_disconnected(id):
	if id > 1:
		for player in Players.get_children():
			Logs.msg(String(id) + " has left.")
	
	destroy_player(id)
