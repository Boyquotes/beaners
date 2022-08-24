extends Spatial

onready var DisconnectedDialog = $"Dialogs/DisconnectedDialog"
onready var FailureConnectionDialog = $"Dialogs/FailureConnectionDialog"

onready var Players = $"Players"
onready var DebugCamera = $"DebugCamera"
onready var Logs = $"Logs"

export var fallzone = -50

func _ready():
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_player_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	# warning-ignore:return_value_discarded
	get_tree().connect("connected_to_server", self, "_lobby_connected")
	# warning-ignore:return_value_discarded
	get_tree().connect("connection_failed", self, "_lobby_connect_failed")
	# warning-ignore:return_value_discarded
	get_tree().connect("server_disconnected", self, "_lobby_disconnected")
	
	if Input.get_mouse_mode() != Input.MOUSE_MODE_HIDDEN:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if is_network_master():
		var name = ConfigWatcher.get_player_config().get_player_name()
		Logs.msg("To connect with friends on this lobby, share your IP address and port with them.")
		load_map(ConfigWatcher.get_lobby_config().get_host_map_selection())
		create_player(get_tree().get_network_unique_id())
		Players.get_node(String(get_tree().get_network_unique_id())).set_player_name(name)
	else:
		Logs.msg("Connecting to the lobby...")

func _process(_delta):
	if Input.is_action_just_pressed("game_debug_cam"):
		if not DebugCamera.is_current():
			for player in Players.get_children():
				if not player.is_network_master(): continue
				player.Camera.clear_current()
				player.set_debug_cam(true)
			
			DebugCamera.make_current()
		else:
			DebugCamera.clear_current()
			
			for player in Players.get_children():
				if not player.is_network_master(): continue
				player.Camera.make_current()
				player.set_debug_cam(false)

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

remote func register_player(info):
	var id = get_tree().get_rpc_sender_id()
	if not Players.has_node(String(id)): return
	if typeof(info) != TYPE_DICTIONARY: return
	if not "name" in info: return
	
	for p in Players.get_children():
		if p.get_player_name() == info["name"]:
			Logs.msg("Your player name is conflicting with another player's name.")
			Logs.msg("To avoid name conflicts, change your player name to something else.")
			break
	
	var player = Players.get_node(String(id))
	player.set_player_name(info["name"])

remotesync func chat(msg):
	Logs.msg(msg)

remote func chat_blind(msg):
	Logs.msg(msg)

remote func load_map(index):
	if index == 3:
		add_child(load("res://Scenes/maps/Tutorial.tscn").instance())
	if DebugCamera.is_locked():
		DebugCamera.set_lock(false)

func _player_connected(id):
	var map_selection = ConfigWatcher.get_lobby_config().get_host_map_selection()
	var info = {
		"name": ConfigWatcher.get_player_config().get_player_name()
	}
	
	rpc_id(id, "load_map", map_selection)
	rpc_id(id, "register_player", info)
	if is_network_master(): rpc_id(id, "chat_blind", "Welcome to " + info["name"] + "'s lobby!")
	create_player(id)

func _player_disconnected(id):
	if Players.has_node(String(id)):
		var name = Players.get_node(String(id)).get_player_name()
		Logs.msg(name + " has left.")
	
	destroy_player(id)

func _lobby_connected():
	var name = ConfigWatcher.get_player_config().get_player_name()
	Logs.get_node("Logs").set_text("")
	rpc("chat_blind", name + " has joined!")
	create_player(get_tree().get_network_unique_id())
	Players.get_node(String(get_tree().get_network_unique_id())).set_player_name(name)

func _lobby_connect_failed():
	if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
		# Workaround for pausing the game, freeing the mouse
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	FailureConnectionDialog.set_visible(true)

func _lobby_disconnected():
	if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
		# Workaround for pausing the game, freeing the mouse
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	for player in Players.get_children():
		Players.remove_child(player)
		player.queue_free()
	
	DisconnectedDialog.set_visible(true)

func _on_DisconnectedDialog_confirmed():
	get_tree().set_network_peer(null)
	get_tree().set_pause(false)
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/menu/LobbyMenu.tscn")

func _on_FailureConnectionDialog_confirmed():
	get_tree().set_network_peer(null)
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/menu/lobby/LobbyJoinMenu.tscn")
