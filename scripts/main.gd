extends Node2D

@onready var player: Player = $Player
@onready var camera: Camera2D = $Camera2D
@onready var game_manager: GameManager = $GameManager
@onready var enemy_spawner: EnemySpawner = $EnemySpawner
@onready var hud: HUD = $HUD

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
