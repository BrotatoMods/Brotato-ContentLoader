extends "res://singletons/item_service.gd"

const CLOADER_LOG = "Darkly77-ContentLoader"


# func get_set(p_set:int)->SetData:
	# return .get_set(p_set)


# func get_rand_item_from_wave(wave:int, type:int, shop_items:Array = [], prev_shop_items:Array = [], fixed_tier:int = - 1)->ItemParentData:
	# return .get_rand_item_from_wave(wave, type, shop_items, prev_shop_items, fixed_tier)


# Returns eg. "Unarmed"
# This patch means that if the weapon set index is higher than the vanilla
# number (which it will be if custom sets were added via ContentLoader's
# `_weapon_set_setup`), then we're getting the data from the new weapon set,
# which has its name set via its custom `CLSetData` class
func get_weapon_class_text(c:int)->String:
	var vanilla_sets_count = SetData.new().WeaponClass.size()
	if c > (vanilla_sets_count - 1): # eg MEDIEVAL (#14) would be c = 13
		var set_data = sets[c] # ItemService.items - we added the custom sets to this in content_loader.gd > _weapon_set_setup
		return tr(set_data.name)

	return .get_weapon_class_text(c)


# Eg "Unarmed, Support"
# func get_weapon_classes_text(weapon_classes:Array)->String:
	# return .get_weapon_classes_text(weapon_classes)
