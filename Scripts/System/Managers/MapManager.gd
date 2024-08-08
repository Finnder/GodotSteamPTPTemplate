extends Node

@export var lobby_map : PackedScene
@export var lobby_scene_path : String = "res://Scenes/level.tscn"

func spawn_map(data):
	var map = (load(data) as PackedScene).instantiate()
	print_rich("Map ", data, " [b]Loaded[/b]")
	return map
