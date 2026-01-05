extends CanvasLayer
class_name HUD

@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/HealthBar
@onready var xp_bar: ProgressBar = $MarginContainer/VBoxContainer/XPBar
@onready var level_label: Label = $MarginContainer/VBoxContainer/LevelLabel
@onready var time_label: Label = $MarginContainer/VBoxContainer/TimeLabel
@onready var kills_label: Label = $MarginContainer/VBoxContainer/KillsLabel

func _ready() -> void:
	if not health_bar:
		push_warning("Health bar not found in HUD")
	if not xp_bar:
		push_warning("XP bar not found in HUD")

func update_health(current: float, maximum: float) -> void:
	if health_bar:
		health_bar.max_value = maximum
		health_bar.value = current

func update_xp(current: int, required: int) -> void:
	if xp_bar:
		xp_bar.max_value = required
		xp_bar.value = current

func update_level(level: int) -> void:
	if level_label:
		level_label.text = "Level: %d" % level

func update_time(time: float) -> void:
	if time_label:
		var minutes = int(time / 60)
		var seconds = int(time) % 60
		time_label.text = "Time: %02d:%02d" % [minutes, seconds]

func update_kills(kills: int) -> void:
	if kills_label:
		kills_label.text = "Kills: %d" % kills
