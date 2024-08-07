extends Node

@export var network_manager : Node
@export var map_spawner : MultiplayerSpawner
@export var map_manager : Node
@export var menu_manager : Node

@export_group("Local Lobby")
@export var local_addr : String = "127.0.0.1"
@export var local_port : int = 5000
@export var local_max_players : int = 4

@export_group("Steam Lobby")
var steam_lobby_id = 1
@export var lobby_v_box_container : VBoxContainer
@export var steam_local_max_players : int = 4

func _ready():
	map_spawner.spawn_function = map_manager.spawn_map

func setup_local_lobbies():
	pass
	
func create_singleplayer_lobby():
	network_manager.reset_peer()
	map_spawner.spawn(map_manager.get_lobby_map())

func create_local_lobby():	
	network_manager.get_peer().create_server(local_port, local_max_players)
	network_manager.update_multiplayer_peer()
	map_spawner.spawn(map_manager.get_lobby_map())
	
func join_local_lobby():
	network_manager.get_peer().create_client(local_addr, local_port)
	network_manager.update_multiplayer_peer()

func setup_steam_lobbies():
	network_manager.set_peer_mode(network_manager.PeerMode.STEAM)
	network_manager.get_peer().lobby_created.connect(_on_steam_lobby_created)
	Steam.lobby_match_list.connect(_on_steam_lobby_match_list)
	open_steam_lobby_list()

func create_public_lobby():
	network_manager.get_peer().create_lobby(SteamMultiplayerPeer.LOBBY_TYPE_PUBLIC)
	multiplayer.set_multiplayer_peer(network_manager.get_peer())
	map_spawner.spawn(map_manager.get_lobby_map())

func join_public_lobby(id):
	network_manager.get_peer().connect_lobby(id)
	network_manager.update_multiplayer_peer()
	menu_manager.hide_main_canvas()
	steam_lobby_id = id

func _on_steam_lobby_created(connected, id):
	if connected:
		steam_lobby_id = id
		Steam.setLobbyData(steam_lobby_id, "name", str(Steam.getPersonaName() + "'s Lobby"))
		Steam.setLobbyJoinable(steam_lobby_id, true)
		print(steam_lobby_id, " Running")

func open_steam_lobby_list():
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	Steam.requestLobbyList()

func refresh_steam_lobby_list():
	for lobby in lobby_v_box_container.get_children(): 
		lobby.queue_free()
			
	open_steam_lobby_list()
	
func _on_steam_lobby_match_list(lobbies):
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var lobby_player_count = Steam.getNumLobbyMembers(lobby)
		
		var btn = Button.new()
		btn.set_text(str(lobby_name))
		btn.set_size(Vector2(100, 5))	
		btn.connect("pressed", Callable(self, "join_public_lobby").bind(lobby))
		lobby_v_box_container.add_child(btn)
