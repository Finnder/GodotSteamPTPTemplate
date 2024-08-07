extends Node

@onready var map_resource_preloader : ResourcePreloader = $MapResourcePreloader

func spawn_map(data):
	var map = (load(data) as PackedScene).instantiate()
	print_rich("Map ", data, " [b]Loaded[/b]")
	return map

func get_lobby_map():
	return map_resource_preloader.get_resource("LobbyScene")
