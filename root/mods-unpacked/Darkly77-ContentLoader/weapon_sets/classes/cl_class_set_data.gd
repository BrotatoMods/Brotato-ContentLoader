class_name CLSetData
extends Resource

# see: SetData
# see: items/sets/set_data.gd

# Vanilla Reference:
# enum WeaponClass{GUN, PRIMITIVE, HEAVY, ELEMENTAL, UNARMED, PRECISE, BLUNT, SUPPORT, MEDICAL, ETHEREAL, TOOL, EXPLOSIVE, BLADE, MEDIEVAL}
# export (WeaponClass) var weapon_class = WeaponClass.GUN


# Unique ID, eg "set_energy"
export (String) var my_id = ""

# Full name (ie. translation string), eg "SET_ENERGY"
export (String) var name = ""

# Array of bonuses. This works exactly like vanilla set bonuses
export (Array, Array, Resource) var set_bonuses = [[], [], [], [], []]


# Dynamically updated in content_loader.gd
# @todo: This should be local, it's only exported temporarily for easier debugging
# export (int) var set_index = 0 # @todo: I don't think this is used/needed anymore
# export (int) var weapon_class = 0 # @todo: This should replace the var above

#@todo: Cleanup (remove) the stuff above. Might need to remvoe one of these vars as well
var set_index = 0
var weapon_class = 0



#@todo: !! Should we just use weapon_class? (Like vanilla SetData?)


# Vanilla reference:
# {
# 	GUN:0,
# 	PRIMITIVE:1,
# 	HEAVY:2,
# 	ELEMENTAL:3,
# 	UNARMED:4
# 	PRECISE:5,
# 	BLUNT:6,
# 	SUPPORT:7,
# 	MEDICAL:8,
# 	ETHEREAL:9,
# 	TOOL:10,
# 	EXPLOSIVE:11,
# 	BLADE:12,
# 	MEDIEVAL:13,
# }
