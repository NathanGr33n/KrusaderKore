extends CanvasLayer
class_name GameOverUI

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var stats_label: Label = $Panel/MarginContainer/VBoxContainer/StatsLabel
@onready var currency_label: Label = $Panel/MarginContainer/VBoxContainer/CurrencyLabel
@onready var restart_button: Button = $Panel/MarginContainer/VBoxContainer/RestartButton
@onready var menu_button: Button = $Panel/MarginContainer/VBoxContainer/MenuButton

var game_time: float = 0.0
var kills: int = 0
var level: int = 1
var currency_earned: int = 0

signal restart_requested
signal menu_requested

func _ready() -> void:
	hide_panel()
	
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	if menu_button:
		menu_button.pressed.connect(_on_menu_pressed)

func show_game_over(time: float, kill_count: int, player_level: int) -> void:
	game_time = time
	kills = kill_count
	level = player_level
	
	# Calculate currency earned (1 per kill + bonus for time)
	currency_earned = kills + int(time / 60.0) * 5
	
	_update_display()
	show_panel()

func _update_display() -> void:
	if stats_label:
		var minutes = int(game_time / 60)
		var seconds = int(game_time) % 60
		var stats_text = "Time Survived: %02d:%02d\nEnemies Slain: %d\nLevel Reached: %d" % [minutes, seconds, kills, level]
		stats_label.text = stats_text
	
	if currency_label:
		currency_label.text = "Crusader Marks Earned: %d" % currency_earned

func show_panel() -> void:
	if panel:
		panel.show()
	get_tree().paused = true

func hide_panel() -> void:
	if panel:
		panel.hide()
	get_tree().paused = false

func _on_restart_pressed() -> void:
	hide_panel()
	restart_requested.emit()

func _on_menu_pressed() -> void:
	hide_panel()
	menu_requested.emit()

func get_currency_earned() -> int:
	return currency_earned
