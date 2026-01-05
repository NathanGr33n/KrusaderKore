extends Node2D
class_name WeaponBase

## Weapon stats
@export var weapon_name: String = "Base Weapon"
@export var base_damage: float = 10.0
@export var base_cooldown: float = 1.0
@export var attack_range: float = 200.0
@export var projectile_speed: float = 300.0

var player: Player
var cooldown_timer: float = 0.0
var weapon_level: int = 1

func _ready() -> void:
	player = get_parent() as Player
	if not player:
		push_error("Weapon must be child of Player node")

func _process(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta
	else:
		auto_attack()

func auto_attack() -> void:
	var target = find_nearest_enemy()
	if target:
		attack(target)
		cooldown_timer = base_cooldown / (player.cooldown_reduction if player else 1.0)

func find_nearest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var nearest_enemy: Node2D = null
	var nearest_distance: float = attack_range
	
	for enemy in enemies:
		if enemy is Node2D:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < nearest_distance:
				nearest_distance = distance
				nearest_enemy = enemy
	
	return nearest_enemy

func attack(target: Node2D) -> void:
	# Override in derived classes
	pass

func get_damage() -> float:
	return base_damage * (player.might if player else 1.0)
