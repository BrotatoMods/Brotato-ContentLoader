class_name ContentLoader
extends Node

# Content added via ContentLoader is added via `_install_data`, called in:
# mods-unpacked/Darkly77-ContentLoader/extensions/singletons/progress_data.gd

var items = []       # Added to ItemService.items
var weapons = []     # Added to ItemService.weapons
var characters = []  # Added to ItemService.characters
var debug_items = [] # Added to DebugService.items
var sets = []        # Added to ItemService.sets
var challenges = []  # Added to ItemService.challenges

var ContentData = load("res://mods-unpacked/Darkly77-ContentLoader/content_data.gd").new()
const CLOADER_LOG = "Darkly77-ContentLoader"


# Helper method available to mods
func load_data(mod_data_path, mod_name:String = "???"):
	var from_mod_text = ""
	if mod_name != "":
		from_mod_text = " (via "+ mod_name +")"

	ModLoaderUtils.log_info("Loading ContentData" + from_mod_text + " -> " + mod_data_path, CLOADER_LOG)

	var mod_data = load(mod_data_path)

	items.append_array(mod_data.items)
	weapons.append_array(mod_data.weapons)
	characters.append_array(mod_data.characters)
	debug_items.append_array(mod_data.debug_items)
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
	ModLoaderUtils.log_debug(str("characters -> ", characters), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("debug_items -> ", debug_items), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("sets -> ", sets), CLOADER_LOG)
	ModLoaderUtils.log_debug(str("challenges -> ", challenges), CLOADER_LOG)

	_weapon_set_setup()

	# Add loaded content to the game
	ItemService.items.append_array(items)
	ItemService.weapons.append_array(weapons)
	ItemService.characters.append_array(characters)
	ItemService.sets.append_array(sets) # @since 2.1.0
	ChallengeService.challenges.append_array(challenges) # @since 2.1.0

	# Add debug items (which makes you always start with them)
	DebugService.debug_items = DebugService.debug_items.duplicate() # this is needed in case the array is empty
	DebugService.debug_items.append_array(debug_items)

	# Debug: Log all loaded content
	for character in characters:
		ModLoaderUtils.log_debug("Added Character: " + tr(character.name), CLOADER_LOG)
	for item in items:
		ModLoaderUtils.log_debug("Added Item: " + tr(item.name), CLOADER_LOG)
	for weapon in weapons:
		ModLoaderUtils.log_debug("Added Weapon: " + tr(weapon.name) + " (" + weapon.my_id + ")", CLOADER_LOG)
	for debug_item in debug_items:
		ModLoaderUtils.log_debug("Added Debug Item: " + tr(debug_item.name), CLOADER_LOG)
	for set in sets:
		ModLoaderUtils.log_debug("Added Set: " + tr(set.name), CLOADER_LOG)
	for challenge in challenges:
		ModLoaderUtils.log_debug("Added Challenge: " + tr(challenge.name), CLOADER_LOG)

	# Debug: Test if your weapon was added to a specific character
#	for character in ItemService.characters:
#		if character.my_id == "character_mage":
#			for weapon in character.starting_weapons:
#				DebugService.log_data(weapon.my_id)

	# @todo: Make weapon sets work: Contruct a new array of weapon sets, that
	# combines vanilla sets with the new sets added via `sets`

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


# Custom weapon sets setup: Add indexes to the sets
# @todo: We also need a way to apply custom sets to vanilla weapons
func _weapon_set_setup():
	# Vanilla count ATOW: 14
	var vanilla_sets_count = SetData.new().WeaponClass.size()

	# We'll add pairs of `key(my_id):value(set_index)` here, for easier lookup in the weapons loop
	var set_index_dict = {}

	# Loop 1: Set up sets
	for i in sets.size():
		var curr_set = sets[i]

		# Eg. the first custom set will be index: 14 (count of 14, plus i which is 0)
		var set_index = i + vanilla_sets_count

		# Update the set's local var
		curr_set.weapon_class = set_index

		# Add to the temp dict
		set_index_dict[curr_set.my_id] = set_index

		#@todo: use dev_log instead
		ModLoaderUtils.log_info(str("Set index ", str(set_index), " for weapon class: ", curr_set.my_id, " (", tr(curr_set.name), ")"), CLOADER_LOG)

	#@todo: use dev_log instead
	ModLoaderUtils.log_info(str("Custom weapon sets: ", set_index_dict), CLOADER_LOG)

	# Loop 2: Set up weapons with custom sets
	# Updates their weapon_classes prop if they have any custom sets.
	# This basically just converts the array of [CLSetData] set resources into
	# their respective indexes, since vanilla uses indexes.
	# weapon.weapon_classes_cl ([CLSetData]) > weapon.weapon_classes_cl_indexes ([int])
	for weapon in weapons:
		# if weapon is CLWeaponData: # as opposed to `WeaponData`
		if weapon is preload("res://mods-unpacked/Darkly77-ContentLoader/weapon_sets/classes/cl_class_weapon_data.gd"):
			# print("CLWeaponData=" + weapon.my_id)
			var custom_sets = weapon.weapon_classes_cl
			var _vanilla_sets = weapon.weapon_classes # Array of ints (the WeaponClass enum)
			var indexes = []
			for cset in custom_sets:
				indexes.push_back(set_index_dict[cset.my_id])
				# This actually works! It might seem like it shouldn't, because
				# we're pushing indexes that aren't defined in the WeaponClass
				# enum for weapon_data.gd. But this var is actually just an
				# array of ints, so we're free to add whatever we want to it
				weapon.weapon_classes.push_back(set_index_dict[cset.my_id])
			# weapon.weapon_classes_cl_indexes = indexes # @todo: this bit isn't needed anymore, tho it can be useful for debugging
