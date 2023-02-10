extends "res://singletons/challenge_service.gd"

const CLOADER_LOG = "Darkly77-ContentLoader"


# Extensions
# =============================================================================

# n/a - the code below is triggered via the extension in run_data.gd and main.gd


# Custom
# =============================================================================

# Unlocks for different characters on various danger levels
# Usage: Give your challenge an ID like this: `chal_danger_{danger_number}_{character_id}`,
# but remove "character_" in your character name. Eg: `chal_danger_3_mutant` = Win ranger 3 with Mutant`
# Called from:
#   res://mods-unpacked/Darkly77-ContentLoader/extensions/main.gd
#   res://mods-unpacked/Darkly77-ContentLoader/extensions/singletons/run_data.gd
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
		#@todo: Fix this. It created 1449 logs when I tested it (161 logs per challenge, with 9 custom challenges being used)
		# ModLoaderUtils.log_debug("[check_single_custom_challenge] NO: Challenge requirements not met (" + tr(challenge.name) + ")", CLOADER_LOG)
		pass

	return can_unlock_challenge
