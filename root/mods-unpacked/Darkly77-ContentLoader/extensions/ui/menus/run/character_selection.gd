extends "res://ui/menus/run/character_selection.gd"

# Adds more columns for characters
# Default is 12
# Atm this mod sets it to 17, which is the max than can be shown without overflow
# This lets us show up to 16 new characters
# (3 rows, first 2 rows are vanilla, then the first in the 3rd row is vanilla to, ie. Demon)
# In a future update, we'll need to add a scrollbar or something, else new characters will spill offscreen

func _ready()->void:
	_inventory.columns = 17 # default: 12, max: 17
