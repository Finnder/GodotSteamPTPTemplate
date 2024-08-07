extends MultiplayerSpawner

@export var player_scene : PackedScene
var players = {}

func _ready():
	spawn_function = spawn_player
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(remove_player)
	
func spawn_player(data):
	var player = player_scene.instantiate()
	player.set_multiplayer_authority(data)
	players[data] = player
	return player

func remove_player(data):
	players[data].queue_free()
	players.erase(data)
