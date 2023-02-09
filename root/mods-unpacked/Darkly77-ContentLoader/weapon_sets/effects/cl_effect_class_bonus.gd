class_name CLClassBonusEffect
extends Effect

# @todo: This is just copied from vanilla, needs sorting, probably as an extension
# rather than a new effect

# @todo: This doesn't support custom sets yet (CLSetData/CLWeaponData)
# see: ClassBonusEffect
# see: effects/items/class_bonus_effect.gd

# Eg. "+X% more damage with Primitive weapons",
# or "+X% attack speed with Primitive weapons", etc

enum WeaponClass{GUN, PRIMITIVE, HEAVY, ELEMENTAL, UNARMED, PRECISE, BLUNT, SUPPORT, MEDICAL, ETHEREAL, TOOL, EXPLOSIVE, BLADE, MEDIEVAL}

export (WeaponClass) var weapon_class = null
export (String) var stat_displayed_name = "stat_damage"
export (String) var stat_name = "damage"


static func get_id()->String:
	return "class_bonus"


func apply()->void :
	RunData.effects["weapon_class_bonus"].push_back([weapon_class, stat_name, value])


func unapply()->void :
	RunData.effects["weapon_class_bonus"].erase([weapon_class, stat_name, value])


func get_args()->Array:
	return [str(value), tr(stat_displayed_name.to_upper()), tr(ItemService.get_weapon_class_text(weapon_class))]
