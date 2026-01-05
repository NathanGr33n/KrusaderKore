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

### Current Features
- Player character with health, armor, and stat modifiers (might/area/cooldown/faith)
- Enemies spawn in circle around player with increasing frequency
- XP gems automatically move toward player when in range
- Camera follows player
- Level-up system with scaling XP requirements

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

## Next Steps (Phase 2)

- Add more weapon types (Holy Bolt, Crossbow, etc.)
- Implement weapon evolutions
- Add passive relics/upgrades
- Create elite enemies
- Build level-up selection UI
