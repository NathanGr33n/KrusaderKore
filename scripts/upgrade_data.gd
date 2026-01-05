extends Resource
class_name UpgradeData

enum UpgradeType {
	WEAPON,
	RELIC,
	STAT_BOOST
}

@export var upgrade_id: String = ""
@export var upgrade_name: String = ""
@export var description: String = ""
@export var icon_path: String = ""
@export var upgrade_type: UpgradeType = UpgradeType.STAT_BOOST
@export var max_level: int = 5
@export var current_level: int = 0

## Weapon-specific
@export var weapon_scene: PackedScene

## Stat modifications
@export var might_bonus: float = 0.0
@export var area_bonus: float = 0.0
@export var cooldown_bonus: float = 0.0
@export var max_health_bonus: float = 0.0
@export var armor_bonus: float = 0.0
@export var move_speed_bonus: float = 0.0
@export var regen_bonus: float = 0.0
@export var faith_bonus: float = 0.0

## Evolution requirements
@export var evolution_id: String = ""  # What this becomes
@export var required_relic_id: String = ""  # Relic needed to evolve

func can_level_up() -> bool:
	return current_level < max_level

func get_level_description() -> String:
	if current_level == 0:
		return description
	else:
		return "%s (Level %d)" % [description, current_level]
