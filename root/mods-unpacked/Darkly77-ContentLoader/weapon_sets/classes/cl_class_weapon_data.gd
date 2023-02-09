class_name CLWeaponData
extends WeaponData

# see: WeaponData
# see: items/global/weapon_data.gd

# Add a custom property
export (Array, Resource) var weapon_classes_cl: = []


# Dynamically updated in ContentLoader
#@todo: This is only exported temporarily, for easier debugging
#@todo: I don't think this is needed anymore
# export (Array, int) var weapon_classes_cl_indexes: = []
