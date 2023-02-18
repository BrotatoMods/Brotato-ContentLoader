class_name ContentLoader
extends Node

var ContentData = load("res://mods-unpacked/Darkly77-ContentLoader/content_data.gd").new()
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
var custom_debug_items = []   # Added to DebugService.items
var custom_debug_weapons = [] # Added to DebugService.weapons
# var custom_difficulties = []  # Added to ItemService.difficulties

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
	# difficulties = {},
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

# Helper method available to mods
func load_data(mod_data_path, mod_name:String = "UnspecifiedAuthor-UnspecifiedModName"):
	var from_mod_text = ""
	if mod_name != "":
		from_mod_text = " (via "+ mod_name +")"

	ModLoaderUtils.log_info("Loading ContentData" + from_mod_text + " -> " + mod_data_path, CLOADER_LOG)

	if not File.new().file_exists(mod_data_path):
		ModLoaderUtils.log_fatal("Tried to load data from a file that doesn't exist, via the mod %s. The invalid path was: %s" % [mod_name, mod_data_path], CLOADER_LOG)
		return

	var mod_data = load(mod_data_path)

	custom_items.append_array(mod_data.items)
	custom_weapons.append_array(mod_data.weapons)
	custom_characters.append_array(mod_data.characters)
	custom_debug_items.append_array(mod_data.debug_items)
	custom_debug_weapons.append_array(mod_data.debug_weapons)
	custom_sets.append_array(mod_data.sets)
	custom_challenges.append_array(mod_data.challenges)
	custom_upgrades.append_array(mod_data.upgrades)
	custom_consumables.append_array(mod_data.consumables)
	# custom_difficulties.append_array(mod_data.difficulties)

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


# Private
# =============================================================================

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
			# difficulties = [],
		}

	var loop_keys = [
		"items",
		"characters",
		"weapons",
		"sets",
		"challenges",
		"upgrades",
		"consumables",
		# "difficulties",
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

	# Items
	# for i in mod_data.items.size():
	# 	if mod_data.items[i]:
	# 		var data = mod_data.items[i]
	# 		lookup_data_byid.items[data.my_id] = mod_name
	# 		lookup_data_bymod[mod_name]["items"].append(data.my_id)

	# # Characters
	# for i in mod_data.characters.size():
	# 	if mod_data.characters[i]:
	# 		var data = mod_data.characters[i]
	# 		lookup_data_byid.characters[data.my_id] = mod_name
	# 		lookup_data_bymod[mod_name]["characters"].append(data.my_id)
	# # Weapons
	# for i in mod_data.weapons.size():
	# 	if mod_data.weapons[i]:
	# 		var data = mod_data.weapons[i]
	# 		lookup_data_byid.weapons[data.my_id] = mod_name
	# 		lookup_data_bymod[mod_name]["weapons"].append(data.my_id)
	# # Sets
	# for i in mod_data.sets.size():
	# 	if mod_data.sets[i]:
	# 		var data = mod_data.sets[i]
	# 		lookup_data_byid.sets[data.my_id] = mod_name
	# 		lookup_data_bymod[mod_name]["sets"].append(data.my_id)

	# # Challenges
	# for i in mod_data.challenges.size():
	# 	if mod_data.challenges[i]:
	# 		var data = mod_data.challenges[i]
	# 		lookup_data_byid.challenges[data.my_id] = mod_name
	# 		lookup_data_bymod[mod_name]["challenges"].append(data.my_id)

	# # Upgrades
	# for i in mod_data.upgrades.size():
	# 	if mod_data.upgrades[i]:
	# 		var data = mod_data.upgrades[i]
	# 		lookup_data_byid.upgrades[data.my_id] = mod_name
	# 		lookup_data_bymod[mod_name]["upgrades"].append(data.my_id)

	# # Difficulties
	# for i in mod_data.difficulties.size():
	# 	if mod_data.difficulties[i]:
	# 		var data = mod_data.difficulties[i]
	# 		lookup_data_byid.difficulties[data.my_id] = mod_name
	# 		lookup_data_bymod[mod_name]["difficulties"].append(data.my_id)

	# # Consumables
	# for i in mod_data.consumables.size():
	# 	if mod_data.consumables[i]:
	# 		var data = mod_data.consumables[i]
	# 		lookup_data_byid.consumables[data.my_id] = mod_name
	# 		lookup_data_bymod[mod_name]["consumables"].append(data.my_id)


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
	ModLoaderUtils.log_debug(str("debug_items -> ", custom_debug_items), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("debug_weapons -> ", custom_debug_weapons), CLOADER_LOG)

	# Add loaded content to the game
	ItemService.items.append_array(custom_items)
	ItemService.weapons.append_array(custom_weapons)
	ItemService.characters.append_array(custom_characters)
	ItemService.sets.append_array(custom_sets) # @since 2.1.0
	ChallengeService.challenges.append_array(custom_challenges) # @since 2.1.0
	ItemService.upgrades.append_array(custom_upgrades) # @since 5.3.0
	ItemService.consumables.append_array(custom_consumables) # @since 5.3.0

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
	for character in ItemService.characters:
		var character_diff_info = CharacterDifficultyInfo.new(character.my_id)

		for zone in ZoneService.zones:
			if zone.unlocked_by_default:
				character_diff_info.zones_difficulty_info.push_back(ZoneDifficultyInfo.new(zone.my_id))

		ProgressData.difficulties_unlocked.push_back(character_diff_info)

	# DIFFICULTIES
	#
	# Disabled because it causes a crash. Needs a special fix. Also note that
	# this would require increasing `max_selectable_difficulty` and `max_difficulty`
	# variables, and may not actually be possible due to the hardcoded constant
	# of ProgressData.MAX_DIFFICULTY
	#
	# See: `apply_run_won` in main.gd
	# See: `parsed_difficulties` in progress_data.gd
	#
	#for difficulty in custom_difficulties:
		#if difficulty.unlocked_by_default and not ProgressData.difficulties_unlocked.has(difficulty.my_id):
			#ProgressData.difficulties_unlocked.push_back(difficulty.my_id)


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
# Example: lookup_modname_by_itemid("weapon", "weapon_alien_arm_1")
func lookup_modname_by_itemid(item_id:String, type:String) -> String:
	var key = ""
	match type:
		"item":
			key = "items"
		"character":
			key = "characters"
		"weapon":
			key = "weapons"
		"set":
			key = "sets"
		"challenge":
			key = "challenges"
		"upgrade":
			key = "upgrades"
		"consumable":
			key = "consumables"
		# "difficulty":
			# key = "difficulties"

	if lookup_data_byid[key].has(item_id):
		return lookup_data_byid[key][item_id]
	else:
		return "CL_Notice-NotFound"


func lookup_modname_by_itemdata(item_data) -> String:
	if item_data is ItemData:
		return lookup_modname_by_itemid(item_data.my_id, "item")
	elif item_data is CharacterData:
		return lookup_modname_by_itemid(item_data.my_id, "character")
	elif item_data is WeaponData:
		return lookup_modname_by_itemid(item_data.my_id, "weapon")
	elif item_data is SetData:
		return lookup_modname_by_itemid(item_data.my_id, "set")
	elif item_data is ChallengeData: # also applies to ExpandedChallengeData
		return lookup_modname_by_itemid(item_data.my_id, "challenge")
	elif item_data is UpgradeData:
		return lookup_modname_by_itemid(item_data.my_id, "upgrade")
	elif item_data is ConsumableData:
		return lookup_modname_by_itemid(item_data.my_id, "consumable")
	# elif item_data is DifficultyData:
		# return lookup_modname_by_itemid(item_data.my_id, "difficulty")
	else:
		return "CL_Error-UnknownType"
