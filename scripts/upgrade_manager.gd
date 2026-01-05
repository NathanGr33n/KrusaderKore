extends Node
class_name UpgradeManager

var player: Player
var available_upgrades: Array[UpgradeData] = []
var acquired_upgrades: Dictionary = {}  # upgrade_id -> UpgradeData
var acquired_weapons: Array[Node2D] = []
var acquired_relics: Array[String] = []

signal upgrade_selected(upgrade: UpgradeData)

func _ready() -> void:
	_initialize_upgrade_pool()

func set_player(p: Player) -> void:
	player = p

func _initialize_upgrade_pool() -> void:
	# Create basic stat upgrades
	available_upgrades.append(_create_might_upgrade())
	available_upgrades.append(_create_armor_upgrade())
	available_upgrades.append(_create_speed_upgrade())
	available_upgrades.append(_create_area_upgrade())
	available_upgrades.append(_create_cooldown_upgrade())
	available_upgrades.append(_create_health_upgrade())
	available_upgrades.append(_create_regen_upgrade())
	
	# Create weapon upgrades
	available_upgrades.append(_create_holy_bolt_upgrade())
	available_upgrades.append(_create_crossbow_upgrade())
	available_upgrades.append(_create_incense_upgrade())

func _create_might_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "might_boost"
	upgrade.upgrade_name = "Might"
	upgrade.description = "+10% damage"
	upgrade.upgrade_type = UpgradeData.UpgradeType.STAT_BOOST
	upgrade.might_bonus = 0.1
	upgrade.max_level = 5
	return upgrade

func _create_armor_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "iron_discipline"
	upgrade.upgrade_name = "Iron Discipline"
	upgrade.description = "+2 armor"
	upgrade.upgrade_type = UpgradeData.UpgradeType.RELIC
	upgrade.armor_bonus = 2.0
	upgrade.max_level = 5
	return upgrade

func _create_speed_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "desert_wind"
	upgrade.upgrade_name = "Desert Wind"
	upgrade.description = "+10% move speed"
	upgrade.upgrade_type = UpgradeData.UpgradeType.RELIC
	upgrade.move_speed_bonus = 20.0
	upgrade.max_level = 5
	return upgrade

func _create_area_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "banner_jerusalem"
	upgrade.upgrade_name = "Banner of Jerusalem"
	upgrade.description = "+10% area"
	upgrade.upgrade_type = UpgradeData.UpgradeType.RELIC
	upgrade.area_bonus = 0.1
	upgrade.max_level = 5
	return upgrade

func _create_cooldown_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "holy_fervor"
	upgrade.upgrade_name = "Holy Fervor"
	upgrade.description = "+10% cooldown reduction"
	upgrade.upgrade_type = UpgradeData.UpgradeType.STAT_BOOST
	upgrade.cooldown_bonus = 0.1
	upgrade.max_level = 5
	return upgrade

func _create_health_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "max_health"
	upgrade.upgrade_name = "Vitality"
	upgrade.description = "+20 max health"
	upgrade.upgrade_type = UpgradeData.UpgradeType.STAT_BOOST
	upgrade.max_health_bonus = 20.0
	upgrade.max_level = 5
	return upgrade

func _create_regen_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "pilgrims_water"
	upgrade.upgrade_name = "Pilgrim's Water Skin"
	upgrade.description = "+0.5 HP/s regeneration"
	upgrade.upgrade_type = UpgradeData.UpgradeType.RELIC
	upgrade.regen_bonus = 0.5
	upgrade.max_level = 3
	return upgrade

func get_random_upgrades(count: int) -> Array[UpgradeData]:
	var valid_upgrades: Array[UpgradeData] = []
	
	# Filter upgrades that can still level up
	for upgrade in available_upgrades:
		var existing = acquired_upgrades.get(upgrade.upgrade_id)
		if existing:
			if existing.can_level_up():
				valid_upgrades.append(existing)
		else:
			valid_upgrades.append(upgrade)
	
	# Shuffle and return requested count
	valid_upgrades.shuffle()
	var result: Array[UpgradeData] = []
	for i in min(count, valid_upgrades.size()):
		result.append(valid_upgrades[i])
	
	return result

func apply_upgrade(upgrade: UpgradeData) -> void:
	if not player:
		return
	
	# Track the upgrade
	var existing = acquired_upgrades.get(upgrade.upgrade_id)
	if existing:
		existing.current_level += 1
	else:
		upgrade.current_level = 1
		acquired_upgrades[upgrade.upgrade_id] = upgrade
		if upgrade.upgrade_type == UpgradeData.UpgradeType.RELIC:
			acquired_relics.append(upgrade.upgrade_id)
	
	# Apply stat bonuses
	player.might += upgrade.might_bonus
	player.area += upgrade.area_bonus
	player.cooldown_reduction += upgrade.cooldown_bonus
	player.armor += upgrade.armor_bonus
	player.move_speed += upgrade.move_speed_bonus
	player.max_health += upgrade.max_health_bonus
	player.current_health += upgrade.max_health_bonus  # Heal on health increase
	player.health_regen += upgrade.regen_bonus
	
	# Apply weapon if new
	if upgrade.upgrade_type == UpgradeData.UpgradeType.WEAPON and upgrade.weapon_scene:
		var weapon = upgrade.weapon_scene.instantiate()
		if weapon:
			player.add_child(weapon)
			acquired_weapons.append(weapon)
	
	upgrade_selected.emit(upgrade)

func has_relic(relic_id: String) -> bool:
	return acquired_relics.has(relic_id)

func _create_holy_bolt_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "weapon_holy_bolt"
	upgrade.upgrade_name = "Holy Bolt"
	upgrade.description = "Fires homing projectiles at enemies"
	upgrade.upgrade_type = UpgradeData.UpgradeType.WEAPON
	upgrade.weapon_scene = preload("res://scenes/weapon_holy_bolt.tscn")
	upgrade.max_level = 1
	return upgrade

func _create_crossbow_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "weapon_crossbow"
	upgrade.upgrade_name = "Crossbow Volley"
	upgrade.description = "Fires 3 projectiles in a spread"
	upgrade.upgrade_type = UpgradeData.UpgradeType.WEAPON
	upgrade.weapon_scene = preload("res://scenes/weapon_crossbow.tscn")
	upgrade.max_level = 1
	return upgrade

func _create_incense_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "weapon_incense"
	upgrade.upgrade_name = "Incense Burner"
	upgrade.description = "Orbits player, damaging nearby enemies"
	upgrade.upgrade_type = UpgradeData.UpgradeType.WEAPON
	upgrade.weapon_scene = preload("res://scenes/weapon_incense.tscn")
	upgrade.max_level = 1
	return upgrade
