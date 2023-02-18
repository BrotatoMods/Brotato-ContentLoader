class_name ContentData
extends Resource

export (Array, Resource) var characters = []
export (Array, Resource) var items = []
export (Array, Resource) var weapons = []
export (Array, Array, Resource) var weapons_characters = []

export (Array, Resource) var sets = []         # ItemService.sets
export (Array, Resource) var challenges = []   # ChallengeService.challenges
export (Array, Resource) var upgrades = []     # ItemService.upgrades
export (Array, Resource) var consumables = []  # ItemService.consumables
export (Array, Resource) var elites = []       # ItemService.elites
# export (Array, Resource) var difficulties = [] # ItemService.difficulties

# Array of items/weapons to always add
export (Array, Resource) var debug_items = []
export (Array, Resource) var debug_weapons = []
