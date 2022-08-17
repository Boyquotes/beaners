extends Spatial

onready var Logs = $"Logs"
onready var Players = $"Players"

func _ready():
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_lobby_disconnected")
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

func _player_connected(id):
	if id > 1:
		Logs.msg(String(id) + " has joined!")
	else:
		Logs.msg("Welcome to " + String(id) + "'s lobby!")
	
	create_player(id)

func _player_disconnected(id):
	Logs.msg(String(id) + " has left.")
	destroy_player(id)

func _lobby_disconnected():
	get_tree().set_network_peer(null)
	Logs.msg("You were disconnected from the lobby.")
