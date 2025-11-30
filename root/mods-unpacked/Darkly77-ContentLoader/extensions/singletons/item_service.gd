extends "res://singletons/item_service.gd"


func _ready() -> void:
	var content_loader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
	content_loader._install_data()
