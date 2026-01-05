extends Node2D
class_name EnemySpawner

@export var enemy_scene: PackedScene
@export var elite_enemy_scene: PackedScene
@export var xp_gem_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var spawn_distance: float = 600.0
@export var max_enemies: int = 100
@export var elite_spawn_chance: float = 0.1  # 10% chance

var player: Player
var spawn_timer: float = 0.0
var enemies_spawned: int = 0
var game_time: float = 0.0

func _ready() -> void:
	# Find player
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0] as Player
	
	if not enemy_scene:
		push_error("Enemy scene not assigned to spawner")
	
	if not xp_gem_scene:
		push_error("XP gem scene not assigned to spawner")

func _process(delta: float) -> void:
	if not player or not enemy_scene:
		return
	
	game_time += delta
	spawn_timer -= delta
	
	# Adjust spawn rate based on game time (difficulty curve)
	var current_spawn_interval = spawn_interval / (1.0 + game_time / 60.0)
	
	if spawn_timer <= 0:
		var current_enemy_count = get_tree().get_nodes_in_group("enemies").size()
		if current_enemy_count < max_enemies:
			spawn_enemy()
			spawn_timer = current_spawn_interval

func spawn_enemy() -> void:
	# Decide if spawning elite
	var scene_to_spawn = enemy_scene
	if elite_enemy_scene and randf() < elite_spawn_chance:
		scene_to_spawn = elite_enemy_scene
	
	var enemy = scene_to_spawn.instantiate() as Enemy
	if not enemy:
		return
	
	# Spawn at random position around player
	var angle = randf() * TAU
	var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * spawn_distance
	
	enemy.global_position = spawn_pos
	enemy.died.connect(_on_enemy_died)
	
	var parent = get_parent()
	if parent:
		parent.add_child(enemy)
		enemies_spawned += 1

func _on_enemy_died(position: Vector2, xp_value: int) -> void:
	# Spawn XP gem at enemy death position
	if xp_gem_scene:
		var xp_gem = xp_gem_scene.instantiate() as XPGem
		if xp_gem:
			xp_gem.global_position = position
			xp_gem.xp_amount = xp_value
			get_parent().add_child(xp_gem)
