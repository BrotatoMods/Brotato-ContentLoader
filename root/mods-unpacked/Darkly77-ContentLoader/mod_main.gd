extends Node

const CLOADER_LOG = "Darkly77-ContentLoader"
var dir = ""


func _init(modLoader = ModLoader):
	ModLoaderUtils.log_info("Init", CLOADER_LOG)
	dir = modLoader.UNPACKED_DIR + "Darkly77-ContentLoader/"
	_add_child_class()
	_install_extensions(modLoader)


func _ready():
	ModLoaderUtils.log_info("Done", CLOADER_LOG)


func _install_extensions(modLoader):
	# TRANSLATIONS
	modLoader.add_translation_from_resource(dir + "translations/contentloader_text.en.translation")

	# WEAPON CLASSES/SETS
	modLoader.install_script_extension(dir + "extensions/singletons/item_service.gd") # Patch various item funcs to use custom classes

	# CHALLENGES
	# Eg. Danger 5 with X character
	modLoader.install_script_extension(dir + "extensions/main.gd") # Patch `clean_up_room` to run our custom challenge unlock func
	modLoader.install_script_extension(dir + "extensions/singletons/challenge_service.gd") # Challenge checks
	modLoader.install_script_extension(dir + "extensions/singletons/run_data.gd") # Patch `add_weapon` and `add_item` to check custom challenges

	# DEFERRED SETUP
	# This runs ContentLoader._install_data(), but running that func needs to be
	# deferred until after progress_data has finished setting vanilla things up
	modLoader.install_script_extension(dir + "extensions/singletons/progress_data.gd")


# Add ContentLoader as a child of this node (which itself is a child of ModLoader)
# Usage in dependant mods:
# 	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
# 	ContentLoader.load_data("path_to_content_data.tres")
func _add_child_class():
	var ContentLoader = load(dir + "content_loader.gd").new()
	ContentLoader.name = "ContentLoader"
	add_child(ContentLoader)
