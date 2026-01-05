extends Node
class_name GameManager

@export var player: Player
@export var enemy_spawner: EnemySpawner

var is_game_over: bool = false
var game_time: float = 0.0
var kill_count: int = 0

signal game_started
signal game_over
signal stats_updated(time: float, kills: int, level: int)

func _ready() -> void:
	if player:
		player.add_to_group("player")
		player.died.connect(_on_player_died)
	else:
		push_error("Player not assigned to GameManager")
	
	game_started.emit()

func _process(delta: float) -> void:
	if not is_game_over:
		game_time += delta
		
		if player:
			stats_updated.emit(game_time, kill_count, player.level)

func _on_player_died() -> void:
	is_game_over = true
	game_over.emit()
	
	# Stop spawning
	if enemy_spawner:
		enemy_spawner.set_process(false)

func add_kill() -> void:
	kill_count += 1
