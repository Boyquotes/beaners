extends Spatial

onready var DisconnectedDialog = $"Dialogs/DisconnectedDialog"

onready var Logs = $"Logs"
onready var Players = $"Players"

export var fallzone = -50

func _ready():
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_lobby_disconnected")
	create_player(get_tree().get_network_unique_id())
	
	if not is_network_master():
		Logs.msg("Welcome to the joined lobby!")
	
	for peer in get_tree().get_network_connected_peers():
		create_player(peer)

func _physics_process(_delta):
	for player in Players.get_children():
		if player.get_translation().y > fallzone:
			continue
		
		player.set_translation(Vector3(0, 10, 0))

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
	Logs.msg(String(id) + " has joined!")
	create_player(id)

func _player_disconnected(id):
	Logs.msg(String(id) + " has left.")
	destroy_player(id)

func _lobby_disconnected():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Workaround for pause mode
	DisconnectedDialog.set_visible(true)
	
	for player in Players.get_children():
		Players.remove_child(player)
		player.queue_free()

func _on_DisconnectedDialog_confirmed():
	get_tree().set_network_peer(null)
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/menu/LobbyMenu.tscn")
