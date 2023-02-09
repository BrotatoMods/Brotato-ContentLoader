class_name ModData
extends Resource

export (Array, Resource) var items = []
export (Array, Resource) var weapons = []
export (Array, Resource) var characters = []

export (Array, Array, Resource) var weapons_characters = []

# Array of items to always add. Can be used to add an item that provides info
# on the mod (eg. the "! Invasion Mod" item in Invasion)
export (Array, Resource) var debug_items = []
