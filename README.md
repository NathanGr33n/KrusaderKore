# KrusaderKore

A Vampire Survivors-style auto-combat horde-survival roguelite set during the Third Crusade.

## Development Status

### Phase 1 — Prototype (COMPLETE)

✅ Core Systems Implemented:
- **Player Movement**: WASD/Arrow key 8-directional movement
- **Auto-Attack System**: Base weapon class with auto-targeting
- **Longsword Weapon**: 90-degree frontal arc attack
- **Enemy AI**: Chase and melee attack behavior
- **Wave Spawner**: Dynamic enemy spawning with difficulty scaling
- **XP System**: Gem drops, collection, and level-up mechanics
- **HUD**: Health bar, XP bar, level, time, and kill counter
- **Game Manager**: Coordinates all systems and tracks stats

### Phase 2 — Core Systems (COMPLETE)

✅ Systems Implemented:
- **Upgrade System**: Level-up UI with 3 random upgrade choices
- **Passive Relics**: 7 stat-boosting relics (Might, Armor, Speed, Area, Cooldown, Health, Regen)
- **Additional Weapons**: Holy Bolt (homing), Crossbow Volley (multi-shot), Incense Burner (orbiting)
- **Projectile System**: Base projectile with homing, pierce, and lifetime mechanics
- **Weapon Evolution**: Weapons evolve when combined with specific relics
  - Longsword + Iron Discipline → Crusader's Great Arc
  - Holy Bolt + Banner of Jerusalem → Dragonpiercer
- **Elite Enemies**: 10% spawn chance for stronger elite variants (100 HP, 10 damage, 5 XP)

### Phase 3 — Content Expansion (COMPLETE)

✅ Content Added:
- **7 Total Weapons**: Longsword, Holy Bolt, Crossbow, Incense, Pilgrim Staff, Throwing Axes, Heavy Mace
- **12 Passive Relics**: Comprehensive stat boost options with multiple upgrade levels
  - Holy Crusade, Blessed Chalice, Divine Favor, Martyr's Resolve, Sacred Texts (new)
- **9 Enemy Types**: Basic, Elite, Archer (ranged), Raider (fast), Mamluk (tank), Ghoul (regen)
- **8 Weapon Evolutions**: Complete evolution paths for all weapons
  - Crossbow + Holy Fervor → Siege Ballista (5 projectiles)
  - Pilgrim Staff + Sacred Texts → Divine Wrath (220px radius)
  - Incense + Desert Wind → Sacred Censers (faster orbit)
- **Weighted Enemy Spawning**: 50% basic, 15% archer, 10% raider, 10% mamluk, 5% ghoul, 10% elite

### Phase 4 — Meta-Progression (COMPLETE)

✅ Meta Systems Implemented:
- **Save/Load System**: JSON-based persistent data storage in user directory
- **3 Playable Characters**: Templar Knight (balanced), Hospitaller (tank/healer), Pilgrim Mystic (faith/AoE)
- **Character Selection Screen**: Full UI for viewing characters, stats, unlock requirements, and starting runs
- **Character Unlock System**: Characters unlock with Crusader Marks (50/100 cost)
- **Meta Currency**: Crusader Marks earned from kills (1 per kill) and survival time (5 per minute)
- **Persistent Upgrade Shop**: 5 permanent upgrades with scaling costs
  - Fortitude: +10 Max Health (10 levels)
  - Blessed Armor: +1 Starting Armor (8 levels)
  - Righteous Fury: +5% Starting Damage (10 levels)
  - Swift Journey: +5 Starting Move Speed (8 levels)
  - Battle Wisdom: +10% XP Gain (5 levels)
- **Run Statistics Tracking**: Persistent tracking of total kills, runs, time survived, best time, highest level
- **Game Over Screen**: Displays run stats, currency earned, with restart and menu options
- **Main Menu System**: Complete menu flow (character select → upgrades shop → game → game over → menu)

### Phase 5 — QA & Polish (COMPLETE)

✅ Polish & Quality:
- **Pause Menu**: ESC key pause with resume, settings, and quit options
- **Difficulty Scaling**: Progressive enemy stat increases (health/damage/XP double at 5 minutes)
- **Balanced Gameplay**: Tuned weapon damage, cooldowns, and upgrade costs
- **Bug Fixes**: Addressed gameplay issues and edge cases
- **Process Mode Management**: Proper pause/unpause handling across all UI layers

### Current Features
- Player with health, armor, regen, and stat modifiers (might/area/cooldown/faith)
- 7 weapon types with unique mechanics (arc, homing, multi-shot, orbiting, radial burst, boomerang, heavy strike)
- 8 weapon evolutions combining weapons with specific relics
- Level-up selection UI with 3 random upgrades from pool of 19 options
- 12 passive relics with multiple upgrade levels
- 9 diverse enemy types with unique behaviors (ranged, fast, tank, regenerating)
- Weighted enemy spawning system for varied encounters
- XP gems automatically move toward player when in range
- Camera follows player
- Health regeneration system

## How to Run

1. Install [Godot 4.2+](https://godotengine.org/download)
2. Open the project in Godot
3. Run the project (F5) or open `scenes/main.tscn`

## Controls

- **WASD / Arrow Keys**: Move
- Weapons auto-attack nearby enemies

## Project Structure

```
├── dev_docs/          # Design documents
├── scenes/            # Godot scene files (.tscn)
│   ├── main.tscn      # Main game scene
│   ├── player.tscn    # Player character
│   ├── enemy.tscn     # Enemy prefab
│   ├── xp_gem.tscn    # XP collectible
│   └── hud.tscn       # User interface
├── scripts/           # GDScript files
│   ├── player.gd      # Player controller
│   ├── enemy.gd       # Enemy AI
│   ├── weapon_base.gd # Base weapon system
│   ├── weapon_longsword.gd  # Longsword implementation
│   ├── xp_gem.gd      # XP collectible
│   ├── enemy_spawner.gd  # Wave spawner
│   ├── game_manager.gd  # Game coordinator
│   ├── hud.gd         # UI controller
│   └── main.gd        # Main scene controller
└── project.godot      # Godot project file
```

## Next Steps (Phase 3)

- Add more weapon and relic varieties (30+ total)
- Create additional enemy types (40+ varieties)
- Build arena generation system
- Add more weapon evolutions
- Implement Crusader-themed art and audio
- Polish gameplay and balance
