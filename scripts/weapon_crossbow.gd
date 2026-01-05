extends WeaponBase
class_name WeaponCrossbow

@export var projectile_scene: PackedScene
@export var projectile_count: int = 3
@export var spread_angle: float = 30.0

func _ready() -> void:
	super._ready()
	weapon_name = "Crossbow Volley"
	base_damage = 8.0
	base_cooldown = 2.0
	attack_range = 500.0
	projectile_speed = 400.0

func attack(target: Node2D) -> void:
	if not projectile_scene:
		return
	
	var base_direction = (target.global_position - global_position).normalized()
	var base_angle = base_direction.angle()
	
	# Fire multiple projectiles in spread pattern
	for i in projectile_count:
		var projectile = projectile_scene.instantiate() as Projectile
		if not projectile:
			continue
		
		# Calculate angle offset for spread
		var angle_offset = 0.0
		if projectile_count > 1:
			var step = deg_to_rad(spread_angle) / (projectile_count - 1)
			angle_offset = -deg_to_rad(spread_angle / 2.0) + (i * step)
		
		var fire_angle = base_angle + angle_offset
		var fire_direction = Vector2(cos(fire_angle), sin(fire_angle))
		
		projectile.global_position = global_position
		projectile.damage = get_damage()
		projectile.speed = projectile_speed
		projectile.pierce_count = 1
		projectile.set_direction(fire_direction)
		
		get_tree().root.add_child(projectile)
