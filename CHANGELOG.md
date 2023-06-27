# Changelog


## [6.2.1 - ModLoader v6](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v6.2.1)

* Update all ModLoader methods for v6 (game version v1.0.0.3)
* **Git Changelog**: [v6.2.0...v6.2.1](https://github.com/BrotatoMods/Brotato-ContentLoader/compare/v6.2.0...v6.2.1)


## [6.2.0 - New API Methods](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v6.2.0)

- Adds 2 new API methods, which allow modders to load content data programatically, without needing a ContentData resource file:
  - `load_data_by_dictionary(content_data_dict: Dictionary, mod_name: String)`
  - `load_data_by_content_data(content_data, mod_name: String)`
- Delays adding content until the last autoload has initialised.
  - ContentLoader now adds its content after Brotato's last autoload (`DebugService`) has initialised, rather than `ProgressData`. This makes it possible for modders to interact with other singletons (eg. `ItemService`) before they add content with ContentLoader.
- See [PR #1](https://github.com/BrotatoMods/Brotato-ContentLoader/pull/1) for full details of this release.
- **Git changelog**: [v6.1.0...v6.2.0](https://github.com/BrotatoMods/Brotato-ContentLoader/compare/v6.1.0...v6.2.0)


## [6.1.0 - Support for Difficulties](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v6.1.0)

- Adds support for custom difficulties
  - This could be used to create custom challenges
  - I haven't tested unlockable difficulties, but in theory it could work
  - You could also award actual challenges (ie. the ones shown in the Progress screen) upon completion of your custom difficulty
  - The difficulties GUI wraps and scrolls just like the character GUI, so you have unlimited space for your own challenge mods.
  - Example mod: [Darkly77-CustomDifficultyModes](https://github.com/BrotatoMods/Darkly77-CustomDifficultyModes)
- **Git Changelog**: [v6.0.1...v6.1.0](https://github.com/BrotatoMods/Brotato-ContentLoader/compare/v6.0.1...v6.1.0)

![image](https://user-images.githubusercontent.com/43499897/219955026-97dcb820-f836-4665-b87a-baa51b059a7d.png)


## [6.0.1 - Bugfix (ItemService)](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v6.0.1)

- Main fix: [fix: duped characters in ItemService.characters](https://github.com/BrotatoMods/Brotato-ContentLoader/commit/d8fe05f5016a71fbeb66150da307b17bbf374000)
  - This _should_ fix vanilla character's Danger progress being wiped when you restart the game
- **Git Changelog**: [v6.0.0...v6.0.1](https://github.com/BrotatoMods/Brotato-ContentLoader/compare/v6.0.0...v6.0.1)


## [6.0.0 - Remove old challenge data](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v6.0.0)

- Remove old custom challenge code (CLChallengeData) - [94a3e73](https://github.com/BrotatoMods/Brotato-ContentLoader/commit/94a3e733f288a8a40c74c6ec98b7d7da8aa92a13)
- Remove redundant .import dir - [4252668](https://github.com/BrotatoMods/Brotato-ContentLoader/commit/4252668a8b1ab225126657becd4d5dbc4209d613)
- This update has **breaking changes**, as it removes the custom challenge code, which has now been moved to [ExpandedChallenges](https://github.com/BrotatoMods/Darkly77-ExpandedChallenges).
- **Git Changelog**: [v5.3.0...v6.0.0](https://github.com/BrotatoMods/Brotato-ContentLoader/compare/v5.3.0...v6.0.0)


## [5.3.0 - Support for Upgrades / Consumables / Elites](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v5.3.0)

### Major Features

* Support for adding upgrades
  * Upgrades have been tested and confirmed as working, consumables/elites have not.
* Support for adding consumables
* Support for adding elites
* Store mod data, to retrieve the mod ID using content's `my_id`
* Add 2 API methods for accessing the stored data
* **Git Changelog**: [v5.2.0...v5.3.0](https://github.com/BrotatoMods/Brotato-ContentLoader/compare/v5.2.0...v5.3.0)

### New Func Details

ContentLoader now stores the names of mods when they add content, and provides 2 new funcs to get this data:

```gdscript
lookup_modname_by_itemid(item_id:String, type:String)
```

Gets the ID of a mod from an item ID ("item" being any content added via ContentLoader).

- `item_id` is always `my_id`.
- `type` is either: `character` / `challenge` / `elite` / `item` / `set` / `upgrade` / `weapon`

```gdscript
lookup_modname_by_itemdata(item_data)
```

- `item_data` is the resource object


## [5.2.0 - Remove GUI code](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v5.2.0)

* Remove the code that makes the character select screen wider, it's been moved to a standalone mod instead ([WiderCharacterSelect](https://github.com/BrotatoMods/Darkly77-WiderCharacterSelect))
* Add an *EXAMPLE.tres* file that can be duplicated to create a new ContentData file (as Godot may not show it in the "new resource" list, which is a bug I've been unable to fix)
- **Git Changelog**: [v5.1.0...v5.2.0](https://github.com/BrotatoMods/Brotato-ContentLoader/compare/v5.1.0...v5.2.0)


## [5.1.0 - File Exists Check](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v5.1.0)

- Check if a file exists before trying to load it with `load_data` (logs a fatal error if it doesn't)
- **Git Changelog**: [v5.0.2...v5.1.0](https://github.com/BrotatoMods/Brotato-ContentLoader/compare/v5.0.2...v5.1.0)


## [5.0.2 - Bugfix](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v5.0.2)

- Fix `clean_up_room` args, since vanilla's 0.8.0.1 patch
- **Git Changelog**: [v5.0.1...v5.0.2](https://github.com/BrotatoMods/Brotato-ContentLoader/compare/v5.0.1...v5.0.2)


## [5.0.1 - Bugfix](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v5.0.1)

- Fix unnecessary `_ready` call in *progress_data.gd*


## [5.0.0 - Workshop Update 2](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v5.0.0)

- Update to be compatible with the latest beta patch (0.8.0.0-v3).
- Remove all code related to the custom weapon sets enum hack (including the custom weapon & set classes).
    - This is a **breaking change**.
    - Create custom sets and add them to your weapons as per the current vanilla beta patch instead.
    - Add the sets as before.
- Remove challenge code related to stat checks.
    - Vanilla now fully supports using custom stats for challenges.
- Update docs to remove mentions of the old custom set classes
- **Git Changelog**: [v4.0.0...v5.0.0](https://github.com/BrotatoMods/Brotato-ContentLoader/compare/v4.0.0...v5.0.0)

## [4.0.0 - Workshop Update 1](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v4.0.0)

- Updates and fixes for the latest beat patch (v0.8.0.0-v1).
- Adds `debug_weapons`, which works like `debug_items`.


## [3.1.0 - Extra character columns + fixes](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v3.1.0)

- Increases the number of columns on the character select screen, from `12` > `17`.
    - This lets you use up to 16 custom characters, before they get cut off by the GUI.
    - This is a hotfix, to show the extra characters from the recent [Assassin](https://github.com/BrotatoMods/Brotato-Assassin-Mod) port to ModLoader. A more flexible fix will be added later.
- Fix translations
    - The translation file was using the wrong name
- Fix custom characters
    - Adds a fix that's necessary to make custom characters work.
    - Without this, using custom characters will cause a crash on the character selection screen.


## [3.0.2 - Bugfix](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v3****.0.2)

- Fix custom characters causing a crash


## [3.0.1 - Bugfix](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v3.0.1)

- Fix translation file was using the wrong name


## [3.0.0 - Challenges & Weapon Sets](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v3.0.0)

- Add Support for custom weapon sets
- Add Support for custom challenges
  - Support all danger levels above 0 (1, 2, 3, 4, 5)
  - Support for holding specific items/weapons
  - Support for reaching certain stats
  - Support for requiring a certain character for all of the above


## [2.0.0 - ModLoader Update](https://github.com/BrotatoMods/Brotato-ContentLoader/releases/tag/v2.0.0)

- Updated to work with [ModLoader](https://github.com/GodotModding/mod-loader)
