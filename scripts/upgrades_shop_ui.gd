extends Control
class_name UpgradesShopUI

@onready var upgrades_list: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/UpgradesList
@onready var currency_label: Label = $MarginContainer/VBoxContainer/CurrencyLabel
@onready var back_button: Button = $MarginContainer/VBoxContainer/BackButton

var meta_data: MetaData

signal back_requested

func _ready() -> void:
	if back_button:
		back_button.pressed.connect(_on_back_pressed)

func initialize(meta: MetaData) -> void:
	meta_data = meta
	_populate_upgrades()
	_update_currency_display()

func _populate_upgrades() -> void:
	if not upgrades_list or not meta_data:
		return
	
	# Clear existing items
	for child in upgrades_list.get_children():
		child.queue_free()
	
	# Define available upgrades
	var upgrades = [
		{
			"id": "max_health_bonus",
			"name": "Fortitude",
			"description": "+10 Max Health",
			"base_cost": 20,
			"max_level": 10
		},
		{
			"id": "starting_armor",
			"name": "Blessed Armor",
			"description": "+1 Starting Armor",
			"base_cost": 25,
			"max_level": 8
		},
		{
			"id": "starting_damage",
			"name": "Righteous Fury",
			"description": "+5% Starting Damage",
			"base_cost": 30,
			"max_level": 10
		},
		{
			"id": "starting_speed",
			"name": "Swift Journey",
			"description": "+5 Starting Move Speed",
			"base_cost": 15,
			"max_level": 8
		},
		{
			"id": "xp_multiplier",
			"name": "Battle Wisdom",
			"description": "+10% XP Gain",
			"base_cost": 40,
			"max_level": 5
		}
	]
	
	for upgrade_def in upgrades:
		var current_level = meta_data.persistent_upgrades.get(upgrade_def["id"], 0)
		var max_level = upgrade_def["max_level"]
		
		# Create upgrade item
		var item = _create_upgrade_item(upgrade_def, current_level)
		upgrades_list.add_child(item)

func _create_upgrade_item(upgrade_def: Dictionary, current_level: int) -> HBoxContainer:
	var container = HBoxContainer.new()
	container.custom_minimum_size = Vector2(0, 60)
	
	# Info panel
	var info = VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var name_label = Label.new()
	name_label.text = "%s (Level %d/%d)" % [upgrade_def["name"], current_level, upgrade_def["max_level"]]
	info.add_child(name_label)
	
	var desc_label = Label.new()
	desc_label.text = upgrade_def["description"]
	desc_label.add_theme_font_size_override("font_size", 12)
	info.add_child(desc_label)
	
	container.add_child(info)
	
	# Purchase button
	var button = Button.new()
	button.custom_minimum_size = Vector2(150, 0)
	
	var max_level = upgrade_def["max_level"]
	if current_level >= max_level:
		button.text = "MAX LEVEL"
		button.disabled = true
	else:
		var cost = _calculate_cost(upgrade_def["base_cost"], current_level)
		button.text = "Upgrade (%d)" % cost
		button.disabled = meta_data.meta_currency < cost
		button.pressed.connect(_on_purchase_pressed.bind(upgrade_def["id"], cost))
	
	container.add_child(button)
	
	return container

func _calculate_cost(base_cost: int, current_level: int) -> int:
	return int(base_cost * pow(1.5, current_level))

func _on_purchase_pressed(upgrade_id: String, cost: int) -> void:
	if meta_data.purchase_persistent_upgrade(upgrade_id, cost):
		_populate_upgrades()  # Refresh list
		_update_currency_display()

func _update_currency_display() -> void:
	if currency_label and meta_data:
		currency_label.text = "Crusader Marks: %d" % meta_data.meta_currency

func _on_back_pressed() -> void:
	back_requested.emit()
