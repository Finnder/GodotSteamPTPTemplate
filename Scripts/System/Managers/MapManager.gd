extends Node

@export var lobby_map : PackedScene

func spawn_map(data : PackedScene):
	var map = data.instantiate()
	print_rich("Map ", data, " [b]Loaded[/b]")
	return map

func get_lobby_map():
	return lobby_map
