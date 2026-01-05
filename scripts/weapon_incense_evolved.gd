extends WeaponIncense
class_name WeaponIncenseEvolved

func _ready() -> void:
	super._ready()
	weapon_name = "Sacred Censers"
	base_damage = 10.0
	base_cooldown = 0.0
	orbit_radius = 100.0
	orbit_speed = 3.0
	damage_interval = 0.4
