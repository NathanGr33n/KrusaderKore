extends WeaponCrossbow
class_name WeaponCrossbowEvolved

func _ready() -> void:
	super._ready()
	weapon_name = "Siege Ballista"
	base_damage = 15.0
	base_cooldown = 1.5
	projectile_count = 5
	spread_angle = 40.0
	attack_range = 600.0
	projectile_speed = 500.0
