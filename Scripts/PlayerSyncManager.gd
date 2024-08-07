extends Node
@onready var camera = $"../Head/Camera3D"

func _ready():
	camera.current = is_multiplayer_authority()
