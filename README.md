# Brotato - ContentLoader

![GitHub all releases](https://img.shields.io/github/downloads/BrotatoMods/Brotato-ContentLoader/total) [^1]

ContentLoader makes it easy to add new content to Brotato.

You can add: *Characters, Items, Weapons, Weapon Sets, Challenges, Elites, Difficulties, Consumables*.

For references, see the mods that use ContentLoader in [Notable Mods](#notable-mods) below.

## TOC

- [Requirements](#requirements)
- [Structure](#structure)
- [Adding Content](#adding-content)
- [ContentData Resources](#contentdata-resources)
- [Items](#items)
- [Characters](#characters)
- [Weapons](#weapons)
- [Weapon's Characters](#weapons-characters)
- [Weapon Sets (Classes)](#weapon-sets-classes)
- [Challenges](#challenges)
- [Debug Items](#debug-items)
- [Appendix](#appendix)


## Requirements

- [ModLoader](https://github.com/GodotModding/godot-mod-loader)
- [Brotils](https://github.com/BrotatoMods/Brotato-Brotils/)


## Structure

You are free to structure your ContentLoader mods however you want, beyond ModLoader's [required structure](https://github.com/GodotModding/godot-mod-loader/wiki/Mod-Structure).

However, I would recommend that you follow the standard set by [Invasion](https://github.com/BrotatoMods/Brotato-Invasion-Mod/tree/main/root/mods-unpacked/Darkly77-Invasion), which uses the following folders:

- `content` - Stores all the custom content, with subfolders for each type (`items`, `weapons`, etc)
- `content_data` - For your *ContentData* resource files
- `extensions` - For code that extends vanilla
- `translations` - Translation CSVs (ie. custom text for item descriptions, etc)

> 💡 *Tip: For your images, it is **highly** recommended that you prefix all filenames with `yourmodname_`. See [.import](https://github.com/GodotModding/godot-mod-loader/wiki/Mod-Structure#import) on the ModLoader Wiki for info on the benefits of this.*


## Adding Content

To add content to the game: In your mod's `_ready()` method, get the ContentLoader class and use its `load_data` method.

```gdscript
func _ready()->void:
	# Get the ContentLoader class
	var ContentLoader = get_node("/root/ModLoader/Darkly77-ContentLoader/ContentLoader")

	var content_dir = "res://mods-unpacked/Author-ModName/content_data/"
	var mod_log = "Author-ModName"

	# Add content. These .tres files are ContentData resources
	ContentLoader.load_data(content_dir + "modname_characters.tres", mod_log)
	ContentLoader.load_data(content_dir + "modname_items.tres", mod_log)
```

> ℹ️ *Note: ModLoader does not support global classes, which is why we need to use the `get_node` approach shown here. See [Advanced > Child Nodes](https://github.com/GodotModding/godot-mod-loader/wiki/Advanced#child-nodes) on the ModLoader Wiki for more info.*


## ContentData Resources

Use the `ContentData` resource class to set up the content you want to add.

To create a new ContentData resource:

- Right-click a folder
- Choose "Add New Resource"
- In the search bar, enter `ContentData`
- Choose the resource shown (it's the *content_data.gd* file)
- You can now add your content by dragging your data files into the respective arrays.

> ℹ *Note: Godot may have an issue where `ContentData` is not available when trying to create a new resource. To fix this, ContentLoader provides an empty ContentData resrouce called* **EXAMPLE.tres**. *It's in ContentLoader's [main mod folder](https://github.com/BrotatoMods/Brotato-ContentLoader/tree/main/root/mods-unpacked/Darkly77-ContentLoader), and you can duplicate this file into your own mod's folders.*

> 💡 *Tip: Once you've created your first ContentData resource, you can create another one quickly by right-clicking it and choosing Duplicate (or click it and use the keyboard shortcut <kbd>Ctrl</kbd> + <kbd>D</kbd>.*

By default, a new ContentData resource looks like this:

![screenshot](.docs/ContentData-empty.png)


## Items

Add ItemData resource files to the **Items** array.

You can drag and drop resource files onto the array box.

![screenshot](.docs/ContentData-items.png)

> ⚠️ *Warning: There's a bug in Godot where if you don't expand the array before you drag items onto it, the existing items may be wiped. So always expand arrays before you add to them!*


## Characters

Add CharacterData resource files to the **Characters** array.

![screenshot](.docs/ContentData-characters.png)


## Weapons

Add WeaponData resources to the **Weapons** array.

In the setup shown here, we've added a weapon called "Chainsaw". Note how each tier of the weapon is added separately.

![screenshot](.docs/ContentData-weapons.png)


## Weapon's Characters

> [!IMPORTANT]
> You can now use the `add_to_chars_as_starting` property in `WeaponData`. This also ensures that the weapon is correctly added to DLC characters.

![screenshot of WeaponData](https://github.com/user-attachments/assets/fc0ce08a-3a09-4ca6-a27d-1a1c0482ea06)

 
<details><summary>Legacy way of adding starting weapons</summary>

<br/>
	
This lists the characters who can start with a weapon. It should be used in the same ContentData resource file that adds the weapon(s).   

It is an array of arrays:

- The top-most array corresponds to the weapons in `weapons`.
- Within each of these arrays, their own array is a list of characters who can start with that weapon.

> 💡 *Tip: Adding each individual weapon as a separate ContentData resource will make using `weapon_characters` much easier.*

### Example 1

This setup adds the 4 tiers for "Chainsaw" (as shown above), and also adds two characters who can start with the Tier 1 version of the weapon (ie. *chainsaw_1_data.tres*, which appears first in the `weapons` array, and so corresponds with the 1st top-level array in **Weapons Characters**):

![screenshot](.docs/ContentData-weapons_characters-tier-1.png)

### Example 2

This next setup does the same, but also adds Knight as a starting character for the Tier 2 version (ie. *chainsaw_2_data.tres*, which appears second in the `weapons` array, and so corresponds with the 2nd top-level array in **Weapons Characters**):

![screenshot](.docs/ContentData-weapons_characters-tier-2.png)

</details>


## Weapon Sets (Classes)

Add your custom weapon set resources to the **Sets** array. They can be added to a weapon's `sets` array just like vanilla sets.

![screenshot](.docs/ContentData-sets.png)


## Challenges

Add Challenge items to the **Challenges** array:

![screenshot](.docs/ContentData-challenges.png)


## Debug Items

Adding items to the "Debug Items" array will add them to every character you play as, for every run. It has the same effect as using the `debug_items` array in DebugService.

You can use it force an item to always be added to the player's inventory, without adding it to the shop pool.

- In an older version of [Invasion](https://github.com/BrotatoMods/Brotato-Invasion-Mod), this was used to add a [special item](https://github.com/BrotatoMods/Brotato-Invasion-Mod/tree/main/root/mods-unpacked/Darkly77-Invasion/content/items/z_info) that showed the current version of the Invasion mod. This special item was not added to the normal Items array, and was not marked as "unlocked by default", which meant it wasn't part of the shop pool.

You can also use it to create a ContentData resource file that adds certain items for your own internal testing. This lets you keep your list of debug items in a single ContentData resource file, which can be selectively enabled/disabled. The advantage to doing this instead of using `DebugService.items` is that you won't need to clear the `items` array when you want to play without all the items.


## Debug Weapons

Same as Debug Items, but for weapons.


## Elites

Adds custom Elites to the pool. Custom Elites are spawned randomly during Elite waves, just like vanilla Elites.


## Difficulties

Adds custom difficulties. Accepts a difficulty resource, which follows the same format as vanilla's difficulties.

For more details, view the README for my example mod: [Darkly77-CustomDifficultyModes](https://github.com/BrotatoMods/Darkly77-CustomDifficultyModes)


## Consumables

Adds custom consumables. Please note that this feature has not been tested.


## API: Loading Content

ContentLoader provides a few methods for loading data:

### load_data

```gdscript
load_data(mod_data_path: String, mod_name: String = "Author-ModName"):
```

Add content from your ContentData resource. Specify the path to your ContentData resource file (*.tres*) with the 1st argument (`mod_data_path`), and specify your mod ID with the 2nd (`mod_name`).

The majority of mods will only ever need to use this method.

```gdscript
# Example:
var content_dir = "res://mods-unpacked/Author-ModName/content_data/"
var mod_log     = "Author-ModName"
ContentLoader.load_data(content_dir + "modname_characters.tres", mod_log)
```

### load_data_by_dictionary

Add content via a dictionary, instead of a ContentData resource. This is an advanced feature that most mods will never use. But for those that want to, it allows you to programatically create mod content on the fly.

```gdscript
load_data_by_dictionary(content_data_dict: Dictionary, mod_name: String = "Author-ModName"):
```

Supports the following keys:

```gdscript
var content_data_dictionary = {
	"items": [],         # ItemData
	"characters": [],    # CharacterData
	"weapons": [],       # WeaponData
	"sets": [],          # SetData
	"challenges": [],    # ChallengeData / ExpandedChallengeData
	"upgrades": [],      # UpgradeData
	"consumables": [],   # ConsumableData
	"elites": [],        # Enemydata
	"difficulties": [],  # DifficultyData
	"debug_items": [],   # ItemData
	"debug_weapons": [], # WeaponData
}
```

Also supports passing a dictionary with a single key, eg:

```gdscript
var content_data_dictionary = { "items": [] }
```

Note that you'll need to create textures from any images on disk. You can use Brotils for this, via [`brotils_create_texture_from_image_path`](https://github.com/BrotatoMods/Brotato-Brotils/tree/main#brotils_create_texture_from_image_path). ContentLoader already depends on Brotils, so you are safe to use this method.

### load_data_by_content_data

```gdscript
load_data_by_content_data(content_data, mod_name: String = "Author-ModName"):
```

Load content from an instance of [ContentData](https://github.com/BrotatoMods/Brotato-ContentLoader/blob/main/root/mods-unpacked/Darkly77-ContentLoader/content_data.gd). Similar to `load_data_by_dictionary`, but allows you to work with a ContentData object instead of JSON. Both have the same result, so which one you want to use depends on your personal preference.

As above, this is also an advanced feature that mods mods will never use.

Note 1: Mods can't use global classes, so you need to load the class before you create a new instance of it, eg:

```gdscript
var content_data = load("res://mods-unpacked/Darkly77-ContentLoader/content_data.gd").new()
```

Note 2: There may be an issue with adding things to the empty arrays of a new ContentData instance, and this can cause your content to be added to every array. To fix this, duplicate your empty arrays before adding to them. An example of how to do this is below. You can also search for `debug_items.duplicate` in the code for the file *content_loader.gd* to see a working example.

```gdscript
var content_data = load("res://mods-unpacked/Darkly77-ContentLoader/content_data.gd").new()
var custom_items = [] # add item resources here

content_data.items = content_data.items.duplicate() # This is needed in case the array is empty
content_data.items.append_array(custom_items)

load_data_by_content_data(content_data, "Author-ModName")
```

## API: Data Lookup

ContentLoader stores all the content it adds, and provides 2 API methods to access the data. Note that while these methods use the string `by_item`, "item" in this case actually means any content added via ContentLoader.

### lookup_modid_by_itemid

```gdscript
lookup_modid_by_itemid(item_id:String, type:String) -> String:
```

Gets the ID of a mod from an item ID.

- `item_id` is always `my_id`.
- `type` is either: `character` / `challenge` / `elite` / `item` / `set` / `upgrade` / `weapon`

### lookup_modid_by_itemdata

```gdscript
lookup_modid_by_itemdata(item_data) -> String:
```

Gets the ID of a mod from a resource object.

- `item_data` is one of these types of objects: (CharacterData / ChallengeData / ConsumableData / SetData / UpgradeData / WeaponData / EnemyData / DifficultyData / ItemData).


## Appendix

### Purpose

ContentLoader adds content to `ItemService`, which is possible without using ContentLoader.

However, it also performs a number of other important functions, including:

- Safely adds custom content to `ProgressData.upgrades_unlocked`.
- Initialises custom characters *(which need to have their own `CharacterDifficultyInfo` object)*.
- Adds custom weapons to corresponding characters.
- Duplicates the debug_items and debug_weapons arrays before adding to them *(which fixes a critical issue in Godot's engine)*.
- Tracks all added content *(allowing any mod to see what content has been added, and by which mod)*.
- Re-runs the applicable vanilla funcs after adding content.


### Notable Mods

The mods listed here were created or ported by Darkly77, ContentLoader's lead developer. They show how to use its various features in a standardised way.

Their *mod_main.gd* file is the entry point for ContentLoader.

| Mod | mod_main.gd |
| --- | ----------- |
| [Assassin](https://github.com/BrotatoMods/Brotato-Assassin-Mod) | [mod_main.gd](https://github.com/BrotatoMods/Brotato-Assassin-Mod/blob/main/root/mods-unpacked/JuneFurrs-Assassin/mod_main.gd) |
| [Invasion](https://github.com/BrotatoMods/Brotato-Invasion-Mod) | [mod_main.gd](https://github.com/BrotatoMods/Brotato-Invasion-Mod/blob/main/root/mods-unpacked/Darkly77-Invasion/ModMain.gd) |

### Credits

ContentLoader was created by [Darkly77](https://github.com/ithinkandicode), with contributions from [KANA](https://github.com/KANAjetzt).

It is based on [dami's Multiple Mod Support](https://github.com/BrotatoMods/Brotato-damis-Multiple-Mod-Support), and its core functionality still uses dami's code.

[^1]: *download counter: the repo had to change so the counter got wiped, was 250, RIP*
