class_name ContentLoader
extends Node

# Name:     ContentLoader
# Version:  2.0.0
# Author:   dami
# Editors:  Darkly77, KANA
# Repo:     https://github.com/BrotatoMods/Brotato-ContentLoader

var items = []       # Added to ItemService.items
var weapons = []     # Added to ItemService.weapons
var characters = []  # Added to ItemService.characters
var debug_items = [] # Added to DebugService.items

var ContentData = load("res://mods-unpacked/Dami-ContentLoader/content_data.gd").new()
const LOG_NAME = "Dami-ContentLoader"


# Helper method available to mods
func load_data(mod_data_path, mod_name:String = "???"):
	ModLoader.dev_log(str("Load data from path -> ", mod_data_path), LOG_NAME)
	var mod_data = load(mod_data_path)
	ModLoader.dev_log(str("Finished loading data from path -> ", mod_data.resource_path), LOG_NAME)

	var from_mod_text = ""
	if mod_name != "":
		from_mod_text = " (via "+ mod_name +")"

	ModLoader.mod_log("Loading ContentData" + from_mod_text + " -> " + mod_data_path, LOG_NAME)

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
					ModLoader.dev_log(str("weapon.my_id -> ", weapon.my_id), LOG_NAME)


# Internal method that adds all custom content to the main game's pools
# (via extensions/singletons/progress_data.gd)
func _install_data():
	ModLoader.mod_log(str("Installing ContentData"), LOG_NAME)
	ModLoader.dev_log(str("items -> ", items), LOG_NAME)
	ModLoader.dev_log(str("weapons -> ", weapons), LOG_NAME)
	ModLoader.dev_log(str("characters -> ", characters), LOG_NAME)
	ModLoader.dev_log(str("debug_items -> ", debug_items), LOG_NAME)

	# Add loaded content to the game
	ItemService.items.append_array(items)
	ItemService.weapons.append_array(weapons)
	ItemService.characters.append_array(characters)

	# Add debug items (which makes you always start with them)
	DebugService.debug_items = DebugService.debug_items.duplicate() # this is needed in case the array is empty
	DebugService.debug_items.append_array(debug_items)

	# Debug: Log all loaded content
	for character in characters:
		ModLoader.dev_log("Added Character: " + tr(character.name), LOG_NAME)
		ModLoader.mod_log("Added Character: " + tr(character.name), LOG_NAME)
	for item in items:
		ModLoader.dev_log("Added Item: " + tr(item.name), LOG_NAME)
		ModLoader.mod_log("Added Item: " + tr(item.name), LOG_NAME)
	for weapon in weapons:
		ModLoader.dev_log("Added Weapon: " + tr(weapon.name), LOG_NAME)
		ModLoader.mod_log("Added Weapon: " + tr(weapon.name), LOG_NAME)
	for debug_item in debug_items:
		ModLoader.dev_log("Added Debug Item: " + tr(debug_item.name), LOG_NAME)
		ModLoader.mod_log("Added Debug Item: " + tr(debug_item.name), LOG_NAME)

	# Debug: Test if your weapon was added to a specific character
#	for character in ItemService.characters:
#		if character.my_id == "character_mage":
#			for weapon in character.starting_weapons:
#				DebugService.log_data(weapon.my_id)

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
