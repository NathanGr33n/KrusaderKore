extends WeaponBase
class_name WeaponPilgrimStaff

@export var burst_radius: float = 150.0

func _ready() -> void:
	super._ready()
	weapon_name = "Pilgrim Staff"
	base_damage = 18.0
	base_cooldown = 1.5
	attack_range = burst_radius

func attack(target: Node2D) -> void:
	# Create radial burst around player
	var enemies = get_tree().get_nodes_in_group("enemies")
	var damage_dealt = 0
	
	for enemy in enemies:
		if enemy is Enemy:
			var distance = global_position.distance_to(enemy.global_position)
			var effective_radius = burst_radius * (player.area if player else 1.0)
			
			if distance <= effective_radius:
				enemy.take_damage(get_damage())
				damage_dealt += 1
	
	# Visual feedback could be added here
