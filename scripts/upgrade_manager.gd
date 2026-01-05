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
	# Register starting weapon (longsword)
	var longsword_upgrade = UpgradeData.new()
	longsword_upgrade.upgrade_id = "weapon_longsword"
	longsword_upgrade.upgrade_name = "Longsword Arc"
	longsword_upgrade.current_level = 1
	acquired_upgrades["weapon_longsword"] = longsword_upgrade
	# Find the existing longsword in player children
	for child in player.get_children():
		if child is WeaponLongsword:
			acquired_weapons.append(child)

func _initialize_upgrade_pool() -> void:
	# Create basic stat upgrades
	available_upgrades.append(_create_might_upgrade())
	available_upgrades.append(_create_armor_upgrade())
	available_upgrades.append(_create_speed_upgrade())
	available_upgrades.append(_create_area_upgrade())
	available_upgrades.append(_create_cooldown_upgrade())
	available_upgrades.append(_create_health_upgrade())
	available_upgrades.append(_create_regen_upgrade())
	available_upgrades.append(_create_pierce_upgrade())
	available_upgrades.append(_create_lifesteal_upgrade())
	available_upgrades.append(_create_luck_upgrade())
	available_upgrades.append(_create_duration_upgrade())
	available_upgrades.append(_create_faith_upgrade())
	
	# Create weapon upgrades
	available_upgrades.append(_create_holy_bolt_upgrade())
	available_upgrades.append(_create_crossbow_upgrade())
	available_upgrades.append(_create_incense_upgrade())
	available_upgrades.append(_create_pilgrim_staff_upgrade())
	available_upgrades.append(_create_throwing_axes_upgrade())
	available_upgrades.append(_create_mace_upgrade())

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
	
	# Check for weapon evolution
	if upgrade.upgrade_type == UpgradeData.UpgradeType.WEAPON:
		_check_weapon_evolution(upgrade.upgrade_id)
	elif upgrade.upgrade_type == UpgradeData.UpgradeType.RELIC:
		# Check all acquired weapons for possible evolution
		for weapon_id in acquired_upgrades.keys():
			if weapon_id.begins_with("weapon_"):
				_check_weapon_evolution(weapon_id)
	
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

func _create_pilgrim_staff_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "weapon_pilgrim_staff"
	upgrade.upgrade_name = "Pilgrim Staff"
	upgrade.description = "Radial burst damaging all nearby enemies"
	upgrade.upgrade_type = UpgradeData.UpgradeType.WEAPON
	upgrade.weapon_scene = preload("res://scenes/weapon_pilgrim_staff.tscn")
	upgrade.max_level = 1
	return upgrade

func _create_throwing_axes_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "weapon_throwing_axes"
	upgrade.upgrade_name = "Throwing Axes"
	upgrade.description = "Boomerang axes that return after traveling"
	upgrade.upgrade_type = UpgradeData.UpgradeType.WEAPON
	upgrade.weapon_scene = preload("res://scenes/weapon_throwing_axes.tscn")
	upgrade.max_level = 1
	return upgrade

func _create_mace_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "weapon_mace"
	upgrade.upgrade_name = "Heavy Mace"
	upgrade.description = "Slow, devastating single-target strikes"
	upgrade.upgrade_type = UpgradeData.UpgradeType.WEAPON
	upgrade.weapon_scene = preload("res://scenes/weapon_mace.tscn")
	upgrade.max_level = 1
	return upgrade

func _create_pierce_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "holy_crusade"
	upgrade.upgrade_name = "Holy Crusade"
	upgrade.description = "+15% might, +5% faith"
	upgrade.upgrade_type = UpgradeData.UpgradeType.RELIC
	upgrade.might_bonus = 0.15
	upgrade.faith_bonus = 0.05
	upgrade.max_level = 3
	return upgrade

func _create_lifesteal_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "blessed_chalice"
	upgrade.upgrade_name = "Blessed Chalice"
	upgrade.description = "+1 HP/s regen, +10 max HP"
	upgrade.upgrade_type = UpgradeData.UpgradeType.RELIC
	upgrade.regen_bonus = 1.0
	upgrade.max_health_bonus = 10.0
	upgrade.max_level = 3
	return upgrade

func _create_luck_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "divine_favor"
	upgrade.upgrade_name = "Divine Favor"
	upgrade.description = "+10% all stats"
	upgrade.upgrade_type = UpgradeData.UpgradeType.RELIC
	upgrade.might_bonus = 0.1
	upgrade.area_bonus = 0.1
	upgrade.cooldown_bonus = 0.1
	upgrade.max_level = 2
	return upgrade

func _create_duration_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "martyrs_resolve"
	upgrade.upgrade_name = "Martyr's Resolve"
	upgrade.description = "+5 armor, +15% cooldown reduction"
	upgrade.upgrade_type = UpgradeData.UpgradeType.RELIC
	upgrade.armor_bonus = 5.0
	upgrade.cooldown_bonus = 0.15
	upgrade.max_level = 2
	return upgrade

func _create_faith_upgrade() -> UpgradeData:
	var upgrade = UpgradeData.new()
	upgrade.upgrade_id = "sacred_texts"
	upgrade.upgrade_name = "Sacred Texts"
	upgrade.description = "+20% faith, +10% area"
	upgrade.upgrade_type = UpgradeData.UpgradeType.RELIC
	upgrade.faith_bonus = 0.2
	upgrade.area_bonus = 0.1
	upgrade.max_level = 3
	return upgrade

func _check_weapon_evolution(weapon_id: String) -> void:
	# Check if this weapon can evolve with acquired relics
	var evolution_map = {
		"weapon_longsword": {
			"relic": "iron_discipline",
			"evolved_scene": preload("res://scenes/weapon_longsword_evolved.tscn")
		},
		"weapon_holy_bolt": {
			"relic": "banner_jerusalem",
			"evolved_scene": preload("res://scenes/weapon_holy_bolt_evolved.tscn")
		}
	}
	
	if not evolution_map.has(weapon_id):
		return
	
	var evolution_data = evolution_map[weapon_id]
	if not has_relic(evolution_data["relic"]):
		return
	
	# Find and remove the old weapon
	for weapon in acquired_weapons:
		if weapon.weapon_name == "Longsword Arc" or weapon.weapon_name == "Holy Bolt":
			weapon.queue_free()
			acquired_weapons.erase(weapon)
			break
	
	# Add the evolved weapon
	var evolved_weapon = evolution_data["evolved_scene"].instantiate()
	if evolved_weapon:
		player.add_child(evolved_weapon)
		acquired_weapons.append(evolved_weapon)
