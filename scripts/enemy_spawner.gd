extends Node2D
class_name EnemySpawner

@export var enemy_scene: PackedScene
@export var elite_enemy_scene: PackedScene
@export var archer_enemy_scene: PackedScene
@export var raider_enemy_scene: PackedScene
@export var mamluk_enemy_scene: PackedScene
@export var ghoul_enemy_scene: PackedScene
@export var xp_gem_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var spawn_distance: float = 600.0
@export var max_enemies: int = 100
@export var elite_spawn_chance: float = 0.1  # 10% chance
@export var difficulty_scale_time: float = 300.0  # Time to reach 2x difficulty

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
	# Select enemy type based on weighted chances
	var scene_to_spawn = _select_enemy_type()
	
	var enemy = scene_to_spawn.instantiate() as Enemy
	if not enemy:
		return
	
	# Apply difficulty scaling
	_apply_difficulty_scaling(enemy)
	
	# Spawn at random position around player
	var angle = randf() * TAU
	var spawn_pos = player.global_position + Vector2(cos(angle), sin(angle)) * spawn_distance
	
	enemy.global_position = spawn_pos
	enemy.died.connect(_on_enemy_died)
	
	var parent = get_parent()
	if parent:
		parent.add_child(enemy)
		enemies_spawned += 1

func _select_enemy_type() -> PackedScene:
	# Weighted enemy selection
	var roll = randf()
	
	# Elite chance (10%)
	if elite_enemy_scene and roll < 0.10:
		return elite_enemy_scene
	
	# Special enemies (40% total)
	if roll < 0.25 and archer_enemy_scene:
		return archer_enemy_scene
	if roll < 0.35 and raider_enemy_scene:
		return raider_enemy_scene
	if roll < 0.45 and mamluk_enemy_scene:
		return mamluk_enemy_scene
	if roll < 0.50 and ghoul_enemy_scene:
		return ghoul_enemy_scene
	
	# Default basic enemy (50%)
	return enemy_scene

func _apply_difficulty_scaling(enemy: Enemy) -> void:
	# Scale enemy stats based on game time
	var difficulty_multiplier = 1.0 + (game_time / difficulty_scale_time)
	
	enemy.max_health *= difficulty_multiplier
	enemy.current_health = enemy.max_health
	enemy.damage *= difficulty_multiplier
	enemy.xp_value = int(enemy.xp_value * difficulty_multiplier)

func _on_enemy_died(position: Vector2, xp_value: int) -> void:
	# Spawn XP gem at enemy death position
	if xp_gem_scene:
		var xp_gem = xp_gem_scene.instantiate() as XPGem
		if xp_gem:
			xp_gem.global_position = position
			xp_gem.xp_amount = xp_value
			get_parent().add_child(xp_gem)
