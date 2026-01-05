extends CanvasLayer
class_name LevelUpUI

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var option1_button: Button = $Panel/MarginContainer/VBoxContainer/Option1
@onready var option2_button: Button = $Panel/MarginContainer/VBoxContainer/Option2
@onready var option3_button: Button = $Panel/MarginContainer/VBoxContainer/Option3

var upgrade_manager: UpgradeManager
var current_options: Array[UpgradeData] = []

signal upgrade_chosen(upgrade: UpgradeData)

func _ready() -> void:
	hide_panel()
	
	if option1_button:
		option1_button.pressed.connect(_on_option1_pressed)
	if option2_button:
		option2_button.pressed.connect(_on_option2_pressed)
	if option3_button:
		option3_button.pressed.connect(_on_option3_pressed)

func set_upgrade_manager(manager: UpgradeManager) -> void:
	upgrade_manager = manager

func show_level_up_options() -> void:
	if not upgrade_manager:
		return
	
	# Get 3 random upgrades
	current_options = upgrade_manager.get_random_upgrades(3)
	
	if current_options.size() == 0:
		hide_panel()
		return
	
	# Update button texts
	if current_options.size() > 0 and option1_button:
		_update_button(option1_button, current_options[0])
		option1_button.show()
	else:
		option1_button.hide()
	
	if current_options.size() > 1 and option2_button:
		_update_button(option2_button, current_options[1])
		option2_button.show()
	else:
		option2_button.hide()
	
	if current_options.size() > 2 and option3_button:
		_update_button(option3_button, current_options[2])
		option3_button.show()
	else:
		option3_button.hide()
	
	show_panel()

func _update_button(button: Button, upgrade: UpgradeData) -> void:
	var text = "%s\n%s" % [upgrade.upgrade_name, upgrade.get_level_description()]
	button.text = text

func show_panel() -> void:
	if panel:
		panel.show()
	get_tree().paused = true

func hide_panel() -> void:
	if panel:
		panel.hide()
	get_tree().paused = false

func _on_option1_pressed() -> void:
	if current_options.size() > 0:
		_select_upgrade(current_options[0])

func _on_option2_pressed() -> void:
	if current_options.size() > 1:
		_select_upgrade(current_options[1])

func _on_option3_pressed() -> void:
	if current_options.size() > 2:
		_select_upgrade(current_options[2])

func _select_upgrade(upgrade: UpgradeData) -> void:
	upgrade_chosen.emit(upgrade)
	current_options.clear()
	hide_panel()
