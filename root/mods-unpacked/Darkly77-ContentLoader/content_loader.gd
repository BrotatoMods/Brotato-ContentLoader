class_name ContentLoader
extends Node

const CLOADER_LOG = "Darkly77-ContentLoader"

# Content added via ContentLoader is added via `_install_data`, called in:
# mods-unpacked/Darkly77-ContentLoader/extensions/singletons/progress_data.gd

var custom_items = []         # Added to ItemService.items
var custom_characters = []    # Added to ItemService.characters
var custom_weapons = []       # Added to ItemService.weapons
var custom_sets = []          # Added to ItemService.sets
var custom_challenges = []    # Added to ChallengeService.challenges
var custom_upgrades = []      # Added to ItemService.upgrades
var custom_consumables = []   # Added to ItemService.consumables
var custom_elites = []        # Added to ItemService.elites
var custom_difficulties = []  # Added to ItemService.difficulties
var custom_debug_items = []   # Added to DebugService.items
var custom_debug_weapons = [] # Added to DebugService.weapons

# Dictionary with the my_id of items as keys.
# Can be used to find the mod name, from the content (item/character/weapon/etc)
var lookup_data_byid = {
	items = {},
	characters = {},
	weapons = {},
	sets = {},
	challenges = {},
	upgrades = {},
	consumables = {},
	elites = {},
	difficulties = {},
}

# Dictionary with mod names as keys.
# Can be used to find content, from the mod name
# Each mod has a dictionary of its content, eg:
#   "Darkly77-Invasion": {
#	  items = ["item_abyssal_pact", "item_alien_biofluid", ...],
#     characters = [],
#     ...
#   }
var lookup_data_bymod = {}


# Main
# =============================================================================

# Add content via a ContentData resource (.tres file)
func load_data(mod_data_path: String, mod_name: String = "UnspecifiedAuthor-UnspecifiedModName"):
	var from_mod_text = ""
	if mod_name != "":
		from_mod_text = " (via "+ mod_name +")"

	ModLoaderUtils.log_info("Loading ContentData" + from_mod_text + " -> " + mod_data_path, CLOADER_LOG)

	if not File.new().file_exists(mod_data_path):
		ModLoaderUtils.log_fatal("Tried to load data from a file that doesn't exist, via the mod %s. The invalid path was: %s" % [mod_name, mod_data_path], CLOADER_LOG)
		return

	var mod_data = load(mod_data_path)

	_add_mod_data(mod_data, mod_name)


# Add content via a dictionary.
# Note that you'll need to have created textures from any images on disk (you
# can use Brotils for this, via `brotils_create_texture_from_image_path`)
# Supports passing a dictionary with a single key, eg:
#   var content_data_dictionary = { "items": [] }
# @since 6.2.0
func load_data_by_dictionary(content_data_dict: Dictionary, mod_name: String = "UnspecifiedAuthor-UnspecifiedModName"):
	var valid_keys := [
		"items",         # ItemData
		"characters",    # CharacterData
		"weapons",       # WeaponData
		"sets",          # SetData
		"challenges",    # ChallengeData / ExpandedChallengeData
		"upgrades",      # UpgradeData
		"consumables",   # ConsumableData
		"elites",        # Enemydata
		"difficulties",  # DifficultyData
		"debug_items",   # ItemData
		"debug_weapons", # WeaponData
	]

	var mod_data = load("res://mods-unpacked/Darkly77-ContentLoader/content_data.gd").new()

	for key in valid_keys:
		if content_data_dict.has(key):
			mod_data[key] = content_data_dict[key]

	_add_mod_data(mod_data, mod_name)


# Load content from an instance of ContentData. Mods can't use global classes,
# so you need to load the class before you create a new instance of it, eg:
#   var content_data = load("res://mods-unpacked/Darkly77-ContentLoader/content_data.gd").new()
# Note: There may be an issue with adding things to the empty arrays of a new
# ContentData instance, and this can cause your content to be added to every
# array. To fix this, duplicate your empty arrays before adding to them.
# Search for `debug_items.duplicate` in the code below to see how this is done
func load_data_by_content_data(content_data, mod_name: String = "UnspecifiedAuthor-UnspecifiedModName"):
	_add_mod_data(content_data, mod_name)


# Private
# =============================================================================

# Adds mod data to the local variables
func _add_mod_data(mod_data, mod_name: String = "UnspecifiedAuthor-UnspecifiedModName"):
	custom_items.append_array(mod_data.items)
	custom_weapons.append_array(mod_data.weapons)
	custom_characters.append_array(mod_data.characters)
	custom_debug_items.append_array(mod_data.debug_items)
	custom_debug_weapons.append_array(mod_data.debug_weapons)
	custom_sets.append_array(mod_data.sets)
	custom_challenges.append_array(mod_data.challenges)
	custom_upgrades.append_array(mod_data.upgrades)
	custom_consumables.append_array(mod_data.consumables)
	custom_elites.append_array(mod_data.elites)
	custom_difficulties.append_array(mod_data.difficulties)

	# Save data to the lookup dictionary
	_save_to_lookup(mod_data, mod_name)

	# Apply weapons_characters: Loops over each weapon and adds it
	# to the corresponding character
	for i in mod_data.weapons_characters.size():
		if mod_data.weapons[i]:
			var wpn_characters = mod_data.weapons_characters[i]
			for character in wpn_characters:
				character.starting_weapons.push_back(mod_data.weapons[i])
				# for weapon in character.starting_weapons:
					# ModLoaderUtils.log_debug(str("weapon.my_id -> ", weapon.my_id), CLOADER_LOG)


# Save data to the lookup dictionary
func _save_to_lookup(mod_data:Resource, mod_name:String = "UnspecifiedAuthor-UnspecifiedModName"):
	# Create a key for this mod in the _bymod dictionary, if it doesn't exist yet
	if not lookup_data_bymod.has(mod_name):
		lookup_data_bymod[mod_name] = {
			items = [],
			characters = [],
			weapons = [],
			sets = [],
			challenges = [],
			upgrades = [],
			consumables = [],
			elites = [],
			difficulties = [],
		}

	var loop_keys = [
		"items",
		"characters",
		"weapons",
		"sets",
		"challenges",
		"upgrades",
		"consumables",
		"elites",
		"difficulties",
	]

	for key_index in loop_keys.size():
		var key = loop_keys[key_index]

		for i in mod_data[key].size():
			if mod_data[key][i]:
				var data = mod_data[key][i]
				lookup_data_byid[key][data.my_id] = mod_name
				lookup_data_bymod[mod_name][key].append(data.my_id)

	# Here's what the code in that loop is doing, using `items` as an example:
	#for i in mod_data.items.size():
		#if mod_data.items[i]:
			#var data = mod_data.items[i]
			#lookup_data_byid.items[data.my_id] = mod_name
			#lookup_data_bymod[mod_name]["items"].append(data.my_id)


# Internal method that adds all custom content to the main game's pools
# (via extensions/singletons/progress_data.gd)
func _install_data():
	ModLoaderUtils.log_info(str("Installing ContentData"), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("items -> ", custom_items), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("weapons -> ", custom_weapons), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("sets -> ", custom_sets), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("characters -> ", custom_characters), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("challenges -> ", custom_challenges), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("upgrades -> ", custom_upgrades), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("consumables -> ", custom_consumables), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("elites -> ", custom_elites), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("difficulties -> ", custom_difficulties), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("debug_items -> ", custom_debug_items), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("debug_weapons -> ", custom_debug_weapons), CLOADER_LOG)

	# Add loaded content to the game
	ItemService.items.append_array(custom_items)
	ItemService.weapons.append_array(custom_weapons)
	ItemService.characters.append_array(custom_characters)
	ItemService.sets.append_array(custom_sets)                  # @since 2.1.0
	ChallengeService.challenges.append_array(custom_challenges) # @since 2.1.0
	ItemService.upgrades.append_array(custom_upgrades)          # @since 5.3.0
	ItemService.consumables.append_array(custom_consumables)    # @since 5.3.0
	ItemService.elites.append_array(custom_elites)              # @since 5.3.0
	ItemService.difficulties.append_array(custom_difficulties)  # @since 6.1.0

	# Add debug items (which makes you always start with them)
	DebugService.debug_items = DebugService.debug_items.duplicate() # this is needed in case the array is empty
	DebugService.debug_weapons = DebugService.debug_weapons.duplicate()
	DebugService.debug_items.append_array(custom_debug_items)
	DebugService.debug_weapons.append_array(custom_debug_weapons)

	# Debug: Log all loaded content
	for character in custom_characters:
		ModLoaderUtils.log_debug("Added Character: " + tr(character.name) + " (" + character.my_id + ")", CLOADER_LOG)
	for item in custom_items:
		ModLoaderUtils.log_debug("Added Item: " + tr(item.name) + " (" + item.my_id + ")", CLOADER_LOG)
	for weapon in custom_weapons:
		ModLoaderUtils.log_debug("Added Weapon: " + tr(weapon.name) + " (" + weapon.my_id + ")", CLOADER_LOG)
	for debug_item in custom_debug_items:
		ModLoaderUtils.log_debug("Added Debug Item: " + tr(debug_item.name), CLOADER_LOG)
	for debug_weapon in custom_debug_weapons:
		ModLoaderUtils.log_debug("Added Debug Item: " + tr(debug_weapon.name), CLOADER_LOG)
	for set in custom_sets:
		ModLoaderUtils.log_debug("Added Set: " + tr(set.name) + " (" + set.my_id + ")", CLOADER_LOG)
	for challenge in custom_challenges:
		ModLoaderUtils.log_debug("Added Challenge: " + tr(challenge.name) + " (" + challenge.my_id + ")", CLOADER_LOG)
	for upgrade in custom_upgrades:
		ModLoaderUtils.log_debug("Added Upgrade: " + tr(upgrade.name) + " (" + upgrade.my_id + ")", CLOADER_LOG)
	for consumable in custom_consumables:
		ModLoaderUtils.log_debug("Added Consumable: " + tr(consumable.name) + " (" + consumable.my_id + ")", CLOADER_LOG)
	for elite in custom_elites:
		ModLoaderUtils.log_debug("Added Elite: " + elite.my_id, CLOADER_LOG)
	for difficulty in custom_difficulties:
		ModLoaderUtils.log_debug("Added Difficulty: " + tr(difficulty.name) + " (" + difficulty.my_id + ")", CLOADER_LOG)

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
# Reference: `init_unlocked_pool` in item_service.gd
# Reference: `add_unlocked_by_default` in progress_data.gd
# @todo: Should we also *lock* items that have `unlocked_by_default` as false?
func _add_unlocked_by_default_without_leak():
	for item in custom_items:
		if item.unlocked_by_default and not ProgressData.items_unlocked.has(item.my_id):
			ProgressData.items_unlocked.push_back(item.my_id)

	for weapon in custom_weapons:
		if weapon.unlocked_by_default and not ProgressData.weapons_unlocked.has(weapon.weapon_id): #@note: NOT my_id
			ProgressData.weapons_unlocked.push_back(weapon.weapon_id)

	for character in custom_characters:
		if character.unlocked_by_default and not ProgressData.characters_unlocked.has(character.my_id):
			ProgressData.characters_unlocked.push_back(character.my_id)

	for upgrade in custom_upgrades:
		if upgrade.unlocked_by_default and not ProgressData.upgrades_unlocked.has(upgrade.upgrade_id): #@note: NOT my_id
			ProgressData.upgrades_unlocked.push_back(upgrade.upgrade_id)

	for consumable in custom_consumables:
		if consumable.unlocked_by_default and not ProgressData.consumables_unlocked.has(consumable.my_id):
			ProgressData.consumables_unlocked.push_back(consumable.my_id)

	# This sets up custom characters to have the data that's needed for them to
	# show correctly in the character selection screen
	for character in custom_characters:
		var character_diff_info = CharacterDifficultyInfo.new(character.my_id)

		for zone in ZoneService.zones:
			if zone.unlocked_by_default:
				character_diff_info.zones_difficulty_info.push_back(ZoneDifficultyInfo.new(zone.my_id))

		# Note that this IS NOT an array of actual difficulties.
		# It's actually an array of CharacterDifficultyInfo objects.
		# Search your save file for `zones_difficulty_info` to see how it looks
		ProgressData.difficulties_unlocked.push_back(character_diff_info)

	# DIFFICULTIES
	#
	# Not needed. But here's some files that use difficulty, for reference:
	#
	# See: difficulty_selection.gd -> get_elements_unlocked
	# See: main.gd -> apply_run_won
	#
	# But ignore pretty much anything in progress_data.gd, that's all related
	# to the CharacterDifficultyInfo objects


# Utility Funcs (Public)
# =============================================================================

# Get name of the mod from the `my_id` for any given item (where "item" could
# be an actual item, or a character, weapon, set or challenge).
#
# If no data was found, returns "CL_Notice-NotFound" (which means it's vanilla)
#
# Note that this may return `AuthorName-ModName` if the mod developer used a
# boilerplate example for their mod and hasn't updated their code with their
# actual mod name yet.
#
# It may also return `UnspecifiedAuthor-UnspecifiedModName`, which means the mod
# developer didn't pass their `mod_name` string when using `load_data`.
#
# Example: lookup_modid_by_itemid("weapon", "weapon_alien_arm_1")
func lookup_modid_by_itemid(item_id:String, type:String) -> String:
	var key = ""
	match type:
		"character":
			key = "characters"
		"challenge":
			key = "challenges"
		"consumable":
			key = "consumables"
		"elite":
			key = "elites"
		"item":
			key = "items"
		"set":
			key = "sets"
		"upgrade":
			key = "upgrades"
		"weapon":
			key = "weapons"
		"difficulty":
			key = "difficulties"

	if lookup_data_byid[key].has(item_id):
		return lookup_data_byid[key][item_id]
	else:
		return "CL_Notice-NotFound"


func lookup_modid_by_itemdata(item_data) -> String:
	if item_data is CharacterData:    return lookup_modid_by_itemid(item_data.my_id, "character")
	elif item_data is ChallengeData:  return lookup_modid_by_itemid(item_data.my_id, "challenge") # Also applies to ExpandedChallengeData
	elif item_data is ConsumableData: return lookup_modid_by_itemid(item_data.my_id, "consumable")
	elif item_data is SetData:        return lookup_modid_by_itemid(item_data.my_id, "set")
	elif item_data is UpgradeData:    return lookup_modid_by_itemid(item_data.my_id, "upgrade")
	elif item_data is WeaponData:     return lookup_modid_by_itemid(item_data.my_id, "weapon")
	elif item_data is EnemyData:      return lookup_modid_by_itemid(item_data.my_id, "elite")
	elif item_data is DifficultyData: return lookup_modid_by_itemid(item_data.my_id, "difficulty")

	# ItemData has to be checked last, because many other classes extend it
	# (CharacterData, ConsumableData, UpgradeData) so it would be `true` for them
	elif item_data is ItemData:       return lookup_modid_by_itemid(item_data.my_id, "item")

	else:
		return "CL_Error-UnknownType"
