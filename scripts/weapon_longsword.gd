extends WeaponBase
class_name WeaponLongsword

@export var arc_angle: float = 90.0

func _ready() -> void:
	super._ready()
	weapon_name = "Longsword Arc"
	base_damage = 15.0
	base_cooldown = 0.8
	attack_range = 150.0

func attack(target: Node2D) -> void:
	# Create arc hitbox in direction of target
	var direction = (target.global_position - global_position).normalized()
	var angle = direction.angle()
	
	# Find all enemies in arc
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy is Enemy:
			var to_enemy = enemy.global_position - global_position
			var distance = to_enemy.length()
			
			if distance <= attack_range:
				var enemy_angle = to_enemy.angle()
				var angle_diff = abs(wrapf(enemy_angle - angle, -PI, PI))
				
				if angle_diff <= deg_to_rad(arc_angle / 2.0):
					enemy.take_damage(get_damage())
