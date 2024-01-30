extends Node

const CLOADER_LOG = "Darkly77-ContentLoader"
var dir = ""
var ext_dir = ""


# Main
# =============================================================================

func _init():
	ModLoaderLog.info("Init", CLOADER_LOG)
	dir = ModLoaderMod.get_unpacked_dir() + "Darkly77-ContentLoader/"
	ext_dir = dir + "extensions/"

	_add_child_class()
	install_script_extensions()


func _ready():
	ModLoaderLog.info("Done", CLOADER_LOG)


# Custom
# =============================================================================

func install_script_extensions():
	# DEFERRED SETUP
	# This runs ContentLoader._install_data(), but running that func needs to be
	# deferred until after progress_data has finished setting vanilla things up.
	# Note: Originally, this extended progress_data, but was changed to the
	# last autoload (DebugService/debug_service) to allow other mods to also
	# wait for ProgressData (or ItemService) to be ready first
	# UPDATE 6.2.2: Changed it to call ContentLoader._install_data() in
	# Utils, so ItemService is populated with all modded data before ProgressData
	# deserializes the save data. With Brotato Patch 1.0.1.3, the function
	# cache_effect_hashes was introduced to ProgressData and causes an error if
	# the modded data is not available in ItemService.
	ModLoaderMod.install_script_extension("res://mods-unpacked/Darkly77-ContentLoader/extensions/singletons/utils.gd")


# Add ContentLoader as a child of this node (which itself is a child of ModLoader)
# Usage in dependant mods:
# 	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
# 	ContentLoader.load_data("path_to_content_data.tres")
func _add_child_class():
	var ContentLoader = load(dir + "content_loader.gd").new()
	ContentLoader.name = "ContentLoader"
	add_child(ContentLoader)
