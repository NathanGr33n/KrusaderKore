extends Node2D

@onready var player: Player = $Player
@onready var camera: Camera2D = $Camera2D
@onready var game_manager: GameManager = $GameManager
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var hud: HUD = $HUD
@onready var upgrade_manager: UpgradeManager = $UpgradeManager
@onready var level_up_ui: LevelUpUI = $LevelUpUI
@onready var game_over_ui: GameOverUI = $GameOverUI
@onready var pause_menu: PauseMenu = $PauseMenu
@onready var meta_data: MetaData = $MetaData

func _ready() -> void:
	# Setup camera to follow player
	if camera and player:
		camera.position = player.position
	
	# Connect game manager
	if game_manager:
		game_manager.player = player
		game_manager.enemy_spawner = enemy_spawner
	
	# Connect HUD to player signals
	if hud and player:
		player.health_changed.connect(hud.update_health)
		player.level_up.connect(hud.update_level)
		player.experience_gained.connect(_on_player_xp_gained)
		hud.update_level(player.level)
		hud.update_health(player.current_health, player.max_health)
	
	# Connect game manager to HUD
	if hud and game_manager:
		game_manager.stats_updated.connect(_on_stats_updated)
	
	# Setup upgrade system
	if upgrade_manager and player:
		upgrade_manager.set_player(player)
	
	if level_up_ui and upgrade_manager:
		level_up_ui.set_upgrade_manager(upgrade_manager)
		level_up_ui.upgrade_chosen.connect(_on_upgrade_chosen)
	
	if player:
		player.level_up.connect(_on_player_level_up)
	
	# Connect game over
	if game_manager and game_over_ui:
		game_manager.game_over.connect(_on_game_over)
	
	if game_over_ui:
		game_over_ui.restart_requested.connect(_on_restart_requested)
		game_over_ui.menu_requested.connect(_on_menu_requested)
	
	# Load meta data
	if meta_data:
		meta_data.load_data()
	
	# Connect pause menu
	if pause_menu:
		pause_menu.quit_requested.connect(_on_pause_quit)

func _process(delta: float) -> void:
	# Camera follows player
	if camera and player:
		camera.position = player.position

func _on_player_xp_gained(exp: int, total_exp: int, exp_to_next: int) -> void:
	if hud:
		hud.update_xp(total_exp, exp_to_next)

func _on_stats_updated(time: float, kills: int, level: int) -> void:
	if hud:
		hud.update_time(time)
		hud.update_kills(kills)

func _on_player_level_up(level: int) -> void:
	if level_up_ui:
		level_up_ui.show_level_up_options()

func _on_upgrade_chosen(upgrade: UpgradeData) -> void:
	if upgrade_manager:
		upgrade_manager.apply_upgrade(upgrade)

func _on_game_over(time: float, kills: int, level: int) -> void:
	if game_over_ui:
		game_over_ui.show_game_over(time, kills, level)
	
	# Save stats to meta progression
	if meta_data:
		var currency = game_over_ui.get_currency_earned()
		meta_data.add_run_stats(kills, time, level, currency)

func _on_restart_requested() -> void:
	get_tree().reload_current_scene()

func _on_menu_requested() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_pause_quit() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
