extends "res://singletons/run_data.gd"


func add_item(item:ItemData)->void:
	.add_item(item)
	ChallengeService.cl_check_custom_completion_challenges()

func add_weapon(weapon:WeaponData, is_starting:bool = false)->WeaponData:
	var weapon_data = .add_weapon(weapon, is_starting)
	ChallengeService.cl_check_custom_completion_challenges()
	return weapon_data
