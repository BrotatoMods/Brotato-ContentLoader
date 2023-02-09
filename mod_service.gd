extends Node

# Name:     dami's multi mod support
# Version:  1.1.0
# Author:   dami
# Editors:  Darkly77 (minor edits)
# Repo:     https://github.com/BrotatoMods/Brotato-damis-Multiple-Mod-Support
#
# Usage: Add to your project and autoload this script. Call it `ModService`.
# You can also edit the config to change where info is logged to

var config = {
	log_to_godotlog = true,  # If true, logs info to: %appdata%/Brotato/godot.log
	log_to_userlog  = true,  # If true, logs info to: %appdata%/Brotato/STEAM_USER_ID/log.txt

	# This settings logs every individual thing that's added. Disabled by default
	# because it'll bloat your log file and slow down the initial startup. Note
	# that .tres files are *always* logged when they're added.
	# ! THIS SHOULD BE FALSE UNLESS YOU'RE DEBUGGING
	log_added_content = false,

	# If true, loads ZIPs from res://mods instead of get_executable_path.
	# This lets you test loading ZIPs in Godot, but prevents you from loading
	# raw files in the mods directory (not sure why).
	# ! THIS SHOULD BE FALSE UNLESS YOU'RE DEBUGGING
	zip_alt_path = false,
}

const mods_dir_path = "res://mods"
var items = []
var weapons = []
var characters = []
var debug_items = [] # items added to DebugService.items

func _ready():
	var path = ""
	path = OS.get_executable_path().get_base_dir() + "/mods"

	if config.zip_alt_path:
		path = mods_dir_path

	debuglog("Ready")

	var mod_dir = Directory.new()

	# Load ZIP files into the resource file system
	debuglog("Looking for mod pack ZIPs... " + "(" + path + ")")
	if mod_dir.open(path) == OK:
		mod_dir.list_dir_begin()
		var mod_name = mod_dir.get_next()
		while mod_name != "":
			if mod_name.get_extension() == "zip" or mod_name.get_extension() == "pck":
				# Load the ZIP, sets `success` to true if it was loaded
				var success = ProjectSettings.load_resource_pack(path + "/" + mod_name, false)
				if success:
					debuglog("Loaded mod pack ZIP: " + mod_name)
				else:
					debuglog("ERROR: Failed to load mod pack ZIP: " + mod_name)
			mod_name = mod_dir.get_next()

	var valid_file_extensions = [
		'tres',       # eg res://mods/mymod_items.tres
		'translation' # eg res://mods/mymod.en.translation
	]

	# Import resources from the mods dir
	debuglog("Importing assets from mod ZIPs... (" + mods_dir_path + ")")
	if mod_dir.open(mods_dir_path) == OK:
		mod_dir.list_dir_begin()
		var mod_data_file = mod_dir.get_next()
		while mod_data_file != "":

			# Ensure we're trying to load a valid file
			if not valid_file_extensions.has(mod_data_file.get_extension()):
				mod_data_file = mod_dir.get_next()
				continue

			var mod_loadpath = mods_dir_path + "/" + mod_data_file
			var mod_data = ResourceLoader.load(mod_loadpath)

			if mod_data is ModData:
				debuglog("Loading ModData: " + mod_loadpath)
				items.append_array(mod_data.items)
				weapons.append_array(mod_data.weapons)
				characters.append_array(mod_data.characters)
				debug_items.append_array(mod_data.debug_items)

				# Apply weapons_characters: Loops over each weapon and adds it
				# to the corresponding character
				for i in mod_data.weapons_characters.size():
					if mod_data.weapons[i]:
						var wpn_characters = mod_data.weapons_characters[i]
						for character in wpn_characters:
							character.starting_weapons.push_back(mod_data.weapons[i])
							for weapon in character.starting_weapons:
								DebugService.log_data(str(weapon.my_id))
			elif mod_data is Translation:
				debuglog("Loading Translation: " + mod_loadpath)
				TranslationServer.add_translation(mod_data)
			else:
				debuglog("WARNING: Loading failed for unknown resource: " + mod_loadpath)
			mod_data_file = mod_dir.get_next()

	# Add loaded content to the game
	ItemService.items.append_array(items)
	ItemService.weapons.append_array(weapons)
	ItemService.characters.append_array(characters)

	# Add debug items (which makes you always start with them)
	DebugService.debug_items = DebugService.debug_items.duplicate() # this is needed in case the array is empty
	DebugService.debug_items.append_array(debug_items)

	# Debug: Log all loaded content
	if config.log_added_content:
		for character in characters:
			debuglog("Added Character: " + tr(character.name))
		for item in items:
			debuglog("Added Item: " + tr(item.name))
		for weapon in weapons:
			debuglog("Added Weapon: " + tr(weapon.name))
		for debug_item in debug_items:
			debuglog("Added Debug Item: " + tr(debug_item.name))

	# Debug: Test if your weapon was added to a specific character
	for character in ItemService.characters:
		if character.my_id == "character_mage":
			for weapon in character.starting_weapons:
				DebugService.log_data(weapon.my_id)

	ItemService.init_unlocked_pool()
	add_unlocked_by_default_without_leak()
	ProgressData.load_game_file()


# Loop over the added content. If its `unlocked_by_default` is true, make sure
# add it to the arrays of unlocked content (which is required to make them appear
# in pools)
func add_unlocked_by_default_without_leak():

	for item in items:
		if item.unlocked_by_default and not ProgressData.items_unlocked.has(item.my_id):
			ProgressData.items_unlocked.push_back(item.my_id)

	for weapon in weapons:
		if weapon.unlocked_by_default and not ProgressData.weapons_unlocked.has(weapon.weapon_id):
			ProgressData.weapons_unlocked.push_back(weapon.weapon_id)

	for character in characters:
		if character.unlocked_by_default and not ProgressData.characters_unlocked.has(character.my_id):
			ProgressData.characters_unlocked.push_back(character.my_id)


func debuglog(text:String):
	var log_prefix = "[mod_service] "
	# Logs to: %appdata%/Brotato/godot.log
	if config.log_to_godotlog:
		print( log_prefix + text )
	# Logs to: %appdata%/Brotato/STEAM_USER_ID/log.txt
	# Or:      %appdata%/Brotato/user/log.txt
	if config.log_to_userlog:
		DebugService.log_data( log_prefix + text )
