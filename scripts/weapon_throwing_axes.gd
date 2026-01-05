extends WeaponBase
class_name WeaponThrowingAxes

@export var projectile_scene: PackedScene
@export var max_distance: float = 300.0
@export var return_speed_multiplier: float = 1.5

func _ready() -> void:
	super._ready()
	weapon_name = "Throwing Axes"
	base_damage = 14.0
	base_cooldown = 1.8
	attack_range = 350.0
	projectile_speed = 400.0

func attack(target: Node2D) -> void:
	if not projectile_scene:
		return
	
	var projectile = projectile_scene.instantiate() as BoomerangProjectile
	if not projectile:
		return
	
	var direction = (target.global_position - global_position).normalized()
	
	projectile.global_position = global_position
	projectile.damage = get_damage()
	projectile.speed = projectile_speed
	projectile.max_distance = max_distance
	projectile.return_speed_multiplier = return_speed_multiplier
	projectile.pierce_count = 999  # Hits everything in path
	projectile.set_direction(direction)
	projectile.set_origin(global_position)
	
	get_tree().root.add_child(projectile)
