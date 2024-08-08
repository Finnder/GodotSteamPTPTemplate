extends MultiplayerSpawner

@export var player_scene : PackedScene
@export var use_spawn_points : bool
@export var spawn_point_container : Node

var players = {}

## INFO: When host connects, peer_connected -> spawn method from the player_spawner (so we don't instance multiple maps)

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

func get_random_spawn_point() -> Node3D:
	var spawn_point_arr : Array[Node3D] = []

	for spawn_point in spawn_point_container.get_children():
		spawn_point_arr.append(spawn_point)
	
	return spawn_point_arr.pick_random()
