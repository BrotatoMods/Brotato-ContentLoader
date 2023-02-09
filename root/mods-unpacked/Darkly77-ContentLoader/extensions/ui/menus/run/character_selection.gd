extends "res://ui/menus/run/character_selection.gd"

# Expands the GUI to make room for more characters/weapons


# Vars
# =============================================================================

# Outermost container, aside from the main MarginContainer.
# Vanilla has a large margin above, but we can reduce that to make more space
onready var _cl_main_container:MarginContainer = $MarginContainer


# Extensions
# =============================================================================

func _ready()->void:
	_cl_adjust_margins()
	_cl_increase_columns()


# Custom
# =============================================================================

# Ideally we would change the margin of the VBoxContainer that is the direct
# child node to the main MarginContainer, but that doesn't work ("children of
# a container get the position and size determined only by their parent")
func _cl_adjust_margins()->void:
	# @todo: Only change this if we need to, ie. if there are more than 16 custom
	# characters that need to be added (as <16 means they'll all fit, via the
	# columns edit below)
	_cl_main_container.set_margin(MARGIN_TOP, -60)


# Adds more columns for characters/weapons
# Default is 12
# Atm this mod sets it to 17, which is the max than can be shown without overflow.
# This lets us show up to 16 new characters (3 rows, first 2 rows are vanilla,
#   then the first in the 3rd row is vanilla to, ie. Demon).
# In a future update, we'll need to add a scrollbar or something, else new
#   characters will spill offscreen
func _cl_increase_columns()->void:
	_inventory.columns = 17 # default: 12, max: 17
