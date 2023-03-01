extends "res://singletons/debug_service.gd"

# We're extending progress_data here because we need the game to finish loading
# its data before we can add items

func _ready():

	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
	ContentLoader._install_data()
