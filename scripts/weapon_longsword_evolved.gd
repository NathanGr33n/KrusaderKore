extends WeaponLongsword
class_name WeaponLongswordEvolved

func _ready() -> void:
	super._ready()
	weapon_name = "Crusader's Great Arc"
	base_damage = 30.0
	base_cooldown = 0.6
	attack_range = 200.0
	arc_angle = 120.0
