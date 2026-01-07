extends Control
class_name CharacterSelectionUI

@onready var character_list: VBoxContainer = $MarginContainer/HBoxContainer/LeftPanel/ScrollContainer/CharacterList
@onready var character_name_label: Label = $MarginContainer/HBoxContainer/RightPanel/VBoxContainer/NameLabel
@onready var character_description: Label = $MarginContainer/HBoxContainer/RightPanel/VBoxContainer/DescriptionLabel
@onready var character_stats: Label = $MarginContainer/HBoxContainer/RightPanel/VBoxContainer/StatsLabel
@onready var unlock_button: Button = $MarginContainer/HBoxContainer/RightPanel/VBoxContainer/UnlockButton
@onready var start_button: Button = $MarginContainer/HBoxContainer/RightPanel/VBoxContainer/StartButton
@onready var upgrades_button: Button = $MarginContainer/HBoxContainer/RightPanel/VBoxContainer/UpgradesButton
@onready var currency_label: Label = $MarginContainer/HBoxContainer/RightPanel/VBoxContainer/CurrencyLabel

var character_manager: CharacterManager
var meta_data: MetaData
var selected_character: CharacterData

signal character_selected(character_data: CharacterData)
signal upgrades_requested

func _ready() -> void:
	if start_button:
		start_button.pressed.connect(_on_start_pressed)
	if unlock_button:
		unlock_button.pressed.connect(_on_unlock_pressed)
	if upgrades_button:
		upgrades_button.pressed.connect(_on_upgrades_pressed)

func initialize(char_manager: CharacterManager, meta: MetaData) -> void:
	character_manager = char_manager
	meta_data = meta
	
	_populate_character_list()
	_update_currency_display()

func _populate_character_list() -> void:
	if not character_list or not character_manager:
		return
	
	# Clear existing buttons
	for child in character_list.get_children():
		child.queue_free()
	
	# Create button for each character
	for character in character_manager.available_characters:
		var button = Button.new()
		button.text = character.character_name
		button.custom_minimum_size = Vector2(200, 50)
		
		# Disable if locked
		var is_locked = not meta_data.is_character_unlocked(character.character_id)
		if is_locked:
			button.text += " [LOCKED]"
			button.disabled = false  # Can still select to view unlock requirements
		
		button.pressed.connect(_on_character_button_pressed.bind(character))
		character_list.add_child(button)
	
	# Select first character by default
	if character_manager.available_characters.size() > 0:
		_select_character(character_manager.available_characters[0])

func _on_character_button_pressed(character: CharacterData) -> void:
	_select_character(character)

func _select_character(character: CharacterData) -> void:
	selected_character = character
	_update_character_display()

func _update_character_display() -> void:
	if not selected_character:
		return
	
	if character_name_label:
		character_name_label.text = selected_character.character_name
	
	if character_description:
		character_description.text = selected_character.description
	
	if character_stats:
		var stats_text = "Health: %.0f\nArmor: %.0f\nSpeed: %.0f\nMight: %.1fx\nArea: %.1fx\nRegen: %.1f HP/s" % [
			selected_character.base_health,
			selected_character.base_armor,
			selected_character.base_move_speed,
			selected_character.base_might,
			selected_character.base_area,
			selected_character.base_regen
		]
		character_stats.text = stats_text
	
	# Update button states
	var is_unlocked = meta_data.is_character_unlocked(selected_character.character_id)
	
	if start_button:
		start_button.disabled = not is_unlocked
	
	if unlock_button:
		if is_unlocked:
			unlock_button.hide()
		else:
			unlock_button.show()
			unlock_button.text = "Unlock (%d Marks)" % selected_character.unlock_cost
			unlock_button.disabled = meta_data.meta_currency < selected_character.unlock_cost

func _update_currency_display() -> void:
	if currency_label and meta_data:
		currency_label.text = "Crusader Marks: %d" % meta_data.meta_currency

func _on_start_pressed() -> void:
	if selected_character and meta_data.is_character_unlocked(selected_character.character_id):
		character_manager.select_character(selected_character.character_id)
		character_selected.emit(selected_character)

func _on_unlock_pressed() -> void:
	if not selected_character or not meta_data:
		return
	
	if meta_data.purchase_persistent_upgrade("unlock_" + selected_character.character_id, selected_character.unlock_cost):
		meta_data.unlock_character(selected_character.character_id)
		_update_character_display()
		_update_currency_display()
		_populate_character_list()  # Refresh list

func _on_upgrades_pressed() -> void:
	upgrades_requested.emit()
