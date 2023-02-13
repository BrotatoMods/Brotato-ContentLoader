extends "res://main.gd"

# Handles danger unlocks


func clean_up_room(is_last_wave:bool = false, is_run_lost:bool = false, is_run_won:bool = false)->void :
	.clean_up_room(is_last_wave, is_run_lost, is_run_won)

	if is_last_wave and not is_run_lost:
		ChallengeService.cl_check_custom_completion_challenges(true)
