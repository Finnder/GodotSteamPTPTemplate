extends Node

@export var app_id : String = "480"

func _ready():
	initialize_steam() 

func initialize_steam() -> void:
	OS.set_environment("SteamAppId", app_id)
	OS.set_environment("SteamGameId", app_id)
	var initialize_response: Dictionary = Steam.steamInitEx()
	
	if initialize_response["status"] == 0:
		print_rich("[color=green]Steam Is Running![/color]")
		
	if initialize_response['status'] > 0:
		print_rich("[color=red]Failed to initialize Steam [/color] | Shutting Down: %s" % initialize_response)
		get_tree().quit()
		
	if !Steam.isSubscribed(): 
		get_tree().quit()

func _process(delta: float) -> void:
	Steam.run_callbacks()
