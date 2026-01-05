extends WeaponBase
class_name WeaponHolyBolt

@export var projectile_scene: PackedScene

func _ready() -> void:
	super._ready()
	weapon_name = "Holy Bolt"
	base_damage = 12.0
	base_cooldown = 1.2
	attack_range = 400.0
	projectile_speed = 350.0

func attack(target: Node2D) -> void:
	if not projectile_scene:
		return
	
	var projectile = projectile_scene.instantiate() as Projectile
	if not projectile:
		return
	
	projectile.global_position = global_position
	projectile.damage = get_damage()
	projectile.speed = projectile_speed
	projectile.is_homing = true
	projectile.set_target(target)
	
	# Set initial direction toward target
	var direction = (target.global_position - global_position).normalized()
	projectile.set_direction(direction)
	
	# Add to scene
	get_tree().root.add_child(projectile)
