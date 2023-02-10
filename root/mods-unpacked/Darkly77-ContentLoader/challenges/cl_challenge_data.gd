class_name CLChallengeData
extends ChallengeData

export (bool) var must_win_run = false
export (Resource) var required_character = null
export (int) var required_danger_number = -1
export (Array, Resource) var required_weapons_and = [] # requires X, Y and Z
export (Array, Resource) var required_weapons_or = [] # requires any of X, Y or Z
export (Array, Resource) var required_items_and = []
export (Array, Resource) var required_items_or = []


# {0} = Character Name
# {1} = Danger Level
# {2} = AND Weapons (if there are two they're joined with "and"; more than 2 are joined with ",")
# {4} = OR Weapons (requires ONE of the specified weapons)
# {3} = AND Items (same join method as above)
# {5} = OR Items
# {6} = Value
# {7} = Stat (translated string)
func get_desc_args()->Array:
	# return [str(value), tr(stat.to_upper())]

	var weapon_names_and = []
	var weapon_names_or = []
	var item_names_and = []
	var item_names_or = []

	var weapon_sep_and = ", " if required_weapons_and.size() > 2 else " & "
	var item_sep_and = ", " if required_items_and.size() > 2 else " & "

	var weapon_sep_or = ", " if required_weapons_or.size() > 2 else " or "
	var item_sep_or = ", " if required_items_or.size() > 2 else " or "

	if required_weapons_and.size() > 0:
		for weapon_data in required_weapons_and:
			if not weapon_names_and.has(tr(weapon_data.name)):
				weapon_names_and.push_back(tr(weapon_data.name))

	if required_weapons_or.size() > 0:
		for weapon_data in required_weapons_or:
			if not weapon_names_or.has(tr(weapon_data.name)):
				weapon_names_or.push_back(tr(weapon_data.name))

	if required_items_and.size() > 0:
		for item_data in required_items_and:
			if not item_names_and.has(tr(item_data.name)):
				item_names_and.push_back(tr(item_data.name))

	if required_items_or.size() > 0:
		for item_data in required_items_or:
			if not item_names_or.has(tr(item_data.name)):
				item_names_or.push_back(tr(item_data.name))

	var req_weapons_and_str = weapon_sep_and.join(weapon_names_and)
	var req_items_and_str = item_sep_and.join(item_names_and)
	var req_weapons_or_str = weapon_sep_or.join(weapon_names_or)
	var req_items_or_str = item_sep_or.join(item_names_or)

	return [
		# {0}
		tr(required_character.name) if required_character != null else "NO CHARACTER SET",
		# {1}
		str(required_danger_number),
		# {2}
		req_weapons_and_str,
		# {3}
		req_weapons_or_str,
		# {4}
		req_items_and_str,
		# {5}
		req_items_or_str,
		# {6}
		str(value),
		# {7}
		tr(stat.to_upper())
	]


# Only used for debugging (@todo: remove?)
func cl_get_challenge_dict()->Dictionary:
	return {
		"character": required_character,
		"danger_number": required_danger_number,
		"weapons_and": required_weapons_and,
		"weapons_or": required_weapons_or,
		"items_and": required_items_and,
		"items_or": required_items_or,
		"must_win_run": must_win_run,
	}
