extends Node

# Usage in dependant mods:
# 	var ContentLoader = get_node("/root/ModLoader/Dami-ContentLoader/ContentLoader")
# 	ContentLoader.load_data("path_to_content_data.tres")

const MOD_NAME = "Dami-ContentLoader"
var dir = ""


func _init(modLoader = ModLoader):
	modLoader.mod_log("Init", MOD_NAME)

	dir = modLoader.UNPACKED_DIR + "Dami-ContentLoader/"

	# Add ContentLoader as a child of this node (which itself is a child of ModLoader)
	var ContentLoader = load(dir + "content_loader.gd").new()
	ContentLoader.name = "ContentLoader"
	add_child(ContentLoader)

	# Add a script to hook into the game when it's finished loading all the
	# vanilla stuff
	modLoader.installScriptExtension(dir + "extensions/singletons/progress_data.gd")


func _ready():
	ModLoader.mod_log("Done", MOD_NAME)
