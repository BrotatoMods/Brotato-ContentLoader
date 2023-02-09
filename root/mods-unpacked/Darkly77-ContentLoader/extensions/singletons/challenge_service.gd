extends "res://singletons/challenge_service.gd"

const CLOADER_LOG = "Darkly77-ContentLoader"


# Extensions
# =============================================================================

# func check_counted_challenges

# Triggered in RunData by: remove_weapon
# Triggered in RunData by: remove_all_weapons
# Triggered in RunData by: apply_item_effects
# Triggered in RunData by: unapply_item_effects
# Triggered in RunData by: add_stat
# Triggered in RunData by: remove_stat
func check_stat_challenges():
	.check_stat_challenges()
	_cl_check_custom_stat_challenges()


# Custom
# =============================================================================

# Patches the stat check challenges to accept any stat. Vanilla is limited as
# its challenges are all hardcoded. This implementation isn't, but stil uses
# vanilla's approach of using `challenge.stat` and `challenge.number` (for the
# stat name, eg stat_max_hp, and the required value). There's a check to ensure
# support for negatives and zero
#@todo: Add support for using `required_character` from the custom challenge
# class (`CLChallengeData`)
func _cl_check_custom_stat_challenges()->void:
	# Vanilla already checks for these challenges, so we need to ignore them
	var vanilla_challenges = [
		get_chal("chal_hallucination"),
		get_chal("chal_fast"),
		get_chal("chal_slow"),
		get_chal("chal_dying"),
		get_chal("chal_perfect_vision"),
		get_chal("chal_agriculture"),
	]

	var vanilla_challenge_ids = []

	# populate vanilla IDs
	for v_challenge in vanilla_challenges:
		vanilla_challenge_ids.push_back(v_challenge.my_id)

	# Loop over challenges
	#@todo: We need to cache an array of challenges that use stats, so that
	# we're not looping over every challenge each time
	for chal in challenges:

		# Ignore vanilla challenges
		if vanilla_challenge_ids.find(chal.my_id) != -1:
			continue

		# Ignore challenegs that aren't related to stats
		if chal.stat == "":
			continue

		# Get sign (-1 is neg / 0 is 0 / 1 is pos)
		var stat_sign = sign(chal.value)

		# Positive: Current stat value should be bigger (or same)
		if stat_sign == 1:
			if Utils.get_stat(chal.stat) >= chal.value:
				complete_challenge(chal.my_id)

		# Negative: Current stat value should be smaller (or same)
		if stat_sign == -1:
			if Utils.get_stat(chal.stat) <= chal.value:
				complete_challenge(chal.my_id)

		# Neutral: Stat should be zero (only relevant for MaxHP?)
		if stat_sign == 0:
			if Utils.get_stat(chal.stat) == 0:
				complete_challenge(chal.my_id)


# Unlocks for different characters on various danger levels
# Usage: Give your challenge an ID like this: `chal_danger_{danger_number}_{character_id}`,
# but remove "character_" in your character name. Eg: `chal_danger_3_mutant` = Win ranger 3 with Mutant`
func cl_check_custom_completion_challenges(won_ron:bool = false)->void:
	for challenge in challenges:
		# if challenge is CLChallengeData:
		if challenge is preload("res://mods-unpacked/Darkly77-ContentLoader/challenges/cl_challenge_data.gd"):
			var _unlocked = _cl_check_single_custom_challenge(challenge, true, won_ron)


# Accepts a custom challenge resource (CLChallengeData/cl_challenge_data.gd)
#   challenge = CLChallengeData
#   do_unlock = True to unlock the challenge. This func returns a bool so you can pass false if you just want to check if a challenge *could* be unlocked
#   won_ron   = True if this is triggered after winning a run. Used to check for danger level completion
func _cl_check_single_custom_challenge(challenge, do_unlock:bool = true, won_ron:bool = false)->bool:
	#@todo: Remove this temp debug logging stuff
	# ModLoaderUtils.log_debug("Checking custom challenge", CLOADER_LOG)
	# ModLoaderUtils.log_debug_json_print("Custom challenge data:", challenge.cl_get_challenge_dict(), CLOADER_LOG)

	var character = challenge.required_character
	var danger_number = challenge.required_danger_number
	var arr_weapons_and = challenge.required_weapons_and
	var arr_weapons_or = challenge.required_weapons_or
	var arr_items_and = challenge.required_items_and
	var arr_items_or = challenge.required_items_or
	var must_win_run = challenge.must_win_run

	# Check stats against the challenge requirements.
	# True by default, then possibly set to false in the code below.
	# If all these are true then the challenge will be unlocked
	var ok_character = true
	var ok_danger_number = true
	var ok_weapons_and = true
	var ok_weapons_or = true
	var ok_items_and = true
	var ok_items_or = true

	var can_unlock_challenge = false

	if character != null:
		ok_character = Utils.brotils_current_character_is(character.my_id)
	else:
		ok_character = true

	if danger_number != -1:
		ok_danger_number = challenge.required_danger_number >= RunData.get_current_difficulty()
	else:
		ok_danger_number = true

	if arr_weapons_and.size() > 0:
		var count_weapons_and = 0
		for weapon in arr_weapons_and:
			if Utils.brotils_has_weapon_any_tier(weapon.weapon_id):
				count_weapons_and += 1
		ok_weapons_and = count_weapons_and == arr_weapons_and.size()

	if arr_weapons_or.size() > 0:
		var count_weapons_or = 0
		for weapon in arr_weapons_or:
			if Utils.brotils_has_weapon_any_tier(weapon.weapon_id):
				count_weapons_or += 1
		ok_weapons_or = count_weapons_or >= 1

	if arr_items_and.size() > 0:
		var count_items_and = 0
		for item in arr_items_and:
			if Utils.brotils_has_item(item.my_id):
				count_items_and += 1
		ok_items_and = count_items_and == arr_items_and.size()

	if arr_items_or.size() > 0:
		var count_items_or = 0
		for item in arr_items_or:
			if Utils.brotils_has_item(item.my_id):
				count_items_or += 1
		ok_items_or = count_items_or >= 1

	if ok_character && ok_danger_number && ok_weapons_and && ok_weapons_or && ok_items_and && ok_items_or:
		can_unlock_challenge = true

	if must_win_run && !won_ron:
		can_unlock_challenge = false

	if can_unlock_challenge:
		ModLoaderUtils.log_debug("[check_single_custom_challenge] OK: Challenge can be unlocked! (" + tr(challenge.name) + ")", CLOADER_LOG)
		if do_unlock:
			complete_challenge(challenge.my_id)
	else:
		ModLoaderUtils.log_debug("[check_single_custom_challenge] NO: Challenge requirements not met (" + tr(challenge.name) + ")", CLOADER_LOG)

	return can_unlock_challenge
