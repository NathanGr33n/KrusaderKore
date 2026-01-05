extends WeaponHolyBolt
class_name WeaponHolyBoltEvolved

func _ready() -> void:
	super._ready()
	weapon_name = "Dragonpiercer"
	base_damage = 25.0
	base_cooldown = 0.9
	attack_range = 500.0

func attack(target: Node2D) -> void:
	if not projectile_scene:
		return
	
	var projectile = projectile_scene.instantiate() as Projectile
	if not projectile:
		return
	
	projectile.global_position = global_position
	projectile.damage = get_damage()
	projectile.speed = projectile_speed * 1.3
	projectile.is_homing = true
	projectile.pierce_count = 3  # Can pierce through enemies
	projectile.set_target(target)
	
	var direction = (target.global_position - global_position).normalized()
	projectile.set_direction(direction)
	
	get_tree().root.add_child(projectile)
