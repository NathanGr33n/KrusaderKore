extends WeaponBase
class_name WeaponIncense

@export var orbit_radius: float = 80.0
@export var orbit_speed: float = 2.0
@export var damage_interval: float = 0.5

var orbit_angle: float = 0.0
var damage_timer: float = 0.0
var hit_cooldowns: Dictionary = {}  # enemy -> cooldown timer

func _ready() -> void:
	super._ready()
	weapon_name = "Incense Burner"
	base_damage = 5.0
	base_cooldown = 0.0  # Always active
	attack_range = orbit_radius + 20.0

func _process(delta: float) -> void:
	# Update orbit position
	orbit_angle += orbit_speed * delta
	var offset = Vector2(cos(orbit_angle), sin(orbit_angle)) * orbit_radius * (player.area if player else 1.0)
	position = offset
	
	# Update damage timer
	damage_timer += delta
	
	# Clean up old hit cooldowns
	var to_remove: Array = []
	for enemy in hit_cooldowns.keys():
		hit_cooldowns[enemy] -= delta
		if hit_cooldowns[enemy] <= 0 or not is_instance_valid(enemy):
			to_remove.append(enemy)
	
	for enemy in to_remove:
		hit_cooldowns.erase(enemy)
	
	# Check for nearby enemies to damage
	if damage_timer >= damage_interval:
		_check_damage_enemies()
		damage_timer = 0.0

func _check_damage_enemies() -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if enemy is Enemy:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < attack_range:
				# Only damage if not on cooldown
				if not hit_cooldowns.has(enemy):
					enemy.take_damage(get_damage())
					hit_cooldowns[enemy] = damage_interval

func auto_attack() -> void:
	# Override to prevent standard attack logic
	pass

func attack(target: Node2D) -> void:
	# Orbiting weapon doesn't use standard attack
	pass
