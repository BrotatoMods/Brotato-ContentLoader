extends Node

const CLOADER_LOG = "Darkly77-ContentLoader"
var dir = ""
var ext_dir = ""


# Main
# =============================================================================

func _init(modLoader = ModLoader):
	ModLoaderUtils.log_info("Init", CLOADER_LOG)
	dir = modLoader.UNPACKED_DIR + "Darkly77-ContentLoader/"
	ext_dir = dir + "extensions/"

	_add_child_class()
	_install_extensions(modLoader)


func _ready():
	ModLoaderUtils.log_info("Done", CLOADER_LOG)


# Custom
# =============================================================================

func _install_extensions(modLoader):
	# DEFERRED SETUP
	# This runs ContentLoader._install_data(), but running that func needs to be
	# deferred until after progress_data has finished setting vanilla things up
	modLoader.install_script_extension(ext_dir + "singletons/progress_data.gd")


# Add ContentLoader as a child of this node (which itself is a child of ModLoader)
# Usage in dependant mods:
# 	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")
# 	ContentLoader.load_data("path_to_content_data.tres")
func _add_child_class():
	var ContentLoader = load(dir + "content_loader.gd").new()
	ContentLoader.name = "ContentLoader"
	add_child(ContentLoader)
