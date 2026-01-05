extends Node2D

@onready var player: Player = $Player
@onready var camera: Camera2D = $Camera2D
@onready var game_manager: GameManager = $GameManager
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var hud: HUD = $HUD
@onready var upgrade_manager: UpgradeManager = $UpgradeManager
@onready var level_up_ui: LevelUpUI = $LevelUpUI

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
