extends CanvasLayer
class_name PauseMenu

@onready var panel: Panel = $Panel
@onready var resume_button: Button = $Panel/MarginContainer/VBoxContainer/ResumeButton
@onready var settings_button: Button = $Panel/MarginContainer/VBoxContainer/SettingsButton
@onready var quit_button: Button = $Panel/MarginContainer/VBoxContainer/QuitButton

var is_paused: bool = false

signal settings_requested
signal quit_requested

func _ready() -> void:
	hide_menu()
	
	if resume_button:
		resume_button.pressed.connect(_on_resume_pressed)
	if settings_button:
		settings_button.pressed.connect(_on_settings_pressed)
	if quit_button:
		quit_button.pressed.connect(_on_quit_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # ESC key
		toggle_pause()

func toggle_pause() -> void:
	if is_paused:
		resume()
	else:
		pause()

func pause() -> void:
	is_paused = true
	show_menu()

func resume() -> void:
	is_paused = false
	hide_menu()

func show_menu() -> void:
	if panel:
		panel.show()
	get_tree().paused = true

func hide_menu() -> void:
	if panel:
		panel.hide()
	get_tree().paused = false

func _on_resume_pressed() -> void:
	resume()

func _on_settings_pressed() -> void:
	settings_requested.emit()

func _on_quit_pressed() -> void:
	quit_requested.emit()
	resume()
