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
