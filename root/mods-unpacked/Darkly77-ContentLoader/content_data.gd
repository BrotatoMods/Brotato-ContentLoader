class_name ContentData
extends Resource

export (Array, Resource) var characters = []
export (Array, Resource) var items = []
export (Array, Resource) var weapons = []
export (Array, Array, Resource) var weapons_characters = []

# Adds to ItemService.sets
export (Array, Resource) var sets = []

# Adds to ChallengeService.challenges
export (Array, Resource) var challenges = []

# Array of items/weapons to always add
export (Array, Resource) var debug_items = []
export (Array, Resource) var debug_weapons = []
