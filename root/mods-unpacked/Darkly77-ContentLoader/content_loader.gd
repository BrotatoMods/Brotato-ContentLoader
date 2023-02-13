class_name ContentLoader
extends Node

# Content added via ContentLoader is added via `_install_data`, called in:
# mods-unpacked/Darkly77-ContentLoader/extensions/singletons/progress_data.gd

var items = []         # Added to ItemService.items
var characters = []    # Added to ItemService.characters
var weapons = []       # Added to ItemService.weapons
var sets = []          # Added to ItemService.sets
var challenges = []    # Added to ItemService.challenges
var debug_items = []   # Added to DebugService.items
var debug_weapons = [] # Added to DebugService.weapons

var ContentData = load("res://mods-unpacked/Darkly77-ContentLoader/content_data.gd").new()
const CLOADER_LOG = "Darkly77-ContentLoader"


# Helper method available to mods
func load_data(mod_data_path, mod_name:String = "???"):
	var from_mod_text = ""
	if mod_name != "":
		from_mod_text = " (via "+ mod_name +")"

	ModLoaderUtils.log_info("Loading ContentData" + from_mod_text + " -> " + mod_data_path, CLOADER_LOG)

	if not File.new().file_exists(mod_data_path):
		ModLoaderUtils.log_fatal("Tried to load data from a file that doesn't exist, via the mod %s. The invalid path was: %s" % [mod_name, mod_data_path], CLOADER_LOG)
		return

	var mod_data = load(mod_data_path)

	items.append_array(mod_data.items)
	weapons.append_array(mod_data.weapons)
	characters.append_array(mod_data.characters)
	debug_items.append_array(mod_data.debug_items)
	debug_weapons.append_array(mod_data.debug_weapons)
	sets.append_array(mod_data.sets)
	challenges.append_array(mod_data.challenges)

	# Apply weapons_characters: Loops over each weapon and adds it
	# to the corresponding character
	for i in mod_data.weapons_characters.size():
		if mod_data.weapons[i]:
			var wpn_characters = mod_data.weapons_characters[i]
			for character in wpn_characters:
				character.starting_weapons.push_back(mod_data.weapons[i])
				# for weapon in character.starting_weapons:
					# ModLoaderUtils.log_debug(str("weapon.my_id -> ", weapon.my_id), CLOADER_LOG)


# Internal method that adds all custom content to the main game's pools
# (via extensions/singletons/progress_data.gd)
func _install_data():
	ModLoaderUtils.log_info(str("Installing ContentData"), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("items -> ", items), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("weapons -> ", weapons), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("sets -> ", sets), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("characters -> ", characters), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("challenges -> ", challenges), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("debug_items -> ", debug_items), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("debug_weapons -> ", debug_weapons), CLOADER_LOG)

	# Add loaded content to the game
	ItemService.items.append_array(items)
	ItemService.weapons.append_array(weapons)
	ItemService.characters.append_array(characters)
	ItemService.sets.append_array(sets) # @since 2.1.0
	ChallengeService.challenges.append_array(challenges) # @since 2.1.0

	# Add debug items (which makes you always start with them)
	DebugService.debug_items = DebugService.debug_items.duplicate() # this is needed in case the array is empty
	DebugService.debug_weapons = DebugService.debug_weapons.duplicate()
	DebugService.debug_items.append_array(debug_items)
	DebugService.debug_weapons.append_array(debug_weapons)

	# Debug: Log all loaded content
	for character in characters:
		ModLoaderUtils.log_debug("Added Character: " + tr(character.name), CLOADER_LOG)
	for item in items:
		ModLoaderUtils.log_debug("Added Item: " + tr(item.name), CLOADER_LOG)
	for weapon in weapons:
		ModLoaderUtils.log_debug("Added Weapon: " + tr(weapon.name) + " (" + weapon.my_id + ")", CLOADER_LOG)
	for debug_item in debug_items:
		ModLoaderUtils.log_debug("Added Debug Item: " + tr(debug_item.name), CLOADER_LOG)
	for debug_weapon in debug_weapons:
		ModLoaderUtils.log_debug("Added Debug Item: " + tr(debug_weapon.name), CLOADER_LOG)
	for set in sets:
		ModLoaderUtils.log_debug("Added Set: " + tr(set.name), CLOADER_LOG)
	for challenge in challenges:
		ModLoaderUtils.log_debug("Added Challenge: " + tr(challenge.name), CLOADER_LOG)

	# Debug: Test if your weapon was added to a specific character
#	for character in ItemService.characters:
#		if character.my_id == "character_mage":
#			for weapon in character.starting_weapons:
#				DebugService.log_data(weapon.my_id)

	ItemService.init_unlocked_pool()
	_add_unlocked_by_default_without_leak()
	ProgressData.load_game_file()


# Loop over the added content. If its `unlocked_by_default` is true, make sure
# add it to the arrays of unlocked content (which is required to make them appear
# in pools)
func _add_unlocked_by_default_without_leak():
	for item in items:
		if item.unlocked_by_default and not ProgressData.items_unlocked.has(item.my_id):
			ProgressData.items_unlocked.push_back(item.my_id)

	for weapon in weapons:
		if weapon.unlocked_by_default and not ProgressData.weapons_unlocked.has(weapon.weapon_id):
			ProgressData.weapons_unlocked.push_back(weapon.weapon_id)

	for character in characters:
		if character.unlocked_by_default and not ProgressData.characters_unlocked.has(character.my_id):
			ProgressData.characters_unlocked.push_back(character.my_id)

	# This sets up custom characters to have the data they need for them to
	# show correctly in the character selection screen
	for character in ItemService.characters:
		var character_diff_info = CharacterDifficultyInfo.new(character.my_id)

		for zone in ZoneService.zones:
			if zone.unlocked_by_default:
				character_diff_info.zones_difficulty_info.push_back(ZoneDifficultyInfo.new(zone.my_id))

		ProgressData.difficulties_unlocked.push_back(character_diff_info)
