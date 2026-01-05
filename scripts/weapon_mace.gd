extends WeaponBase
class_name WeaponMace

@export var strike_radius: float = 100.0
@export var damage_multiplier: float = 2.5

func _ready() -> void:
	super._ready()
	weapon_name = "Heavy Mace"
	base_damage = 35.0
	base_cooldown = 2.5
	attack_range = strike_radius

func attack(target: Node2D) -> void:
	# Heavy single-target strike
	if not target or not is_instance_valid(target):
		return
	
	var distance = global_position.distance_to(target.global_position)
	var effective_radius = strike_radius * (player.area if player else 1.0)
	
	if distance <= effective_radius:
		if target is Enemy:
			target.take_damage(get_damage() * damage_multiplier)
