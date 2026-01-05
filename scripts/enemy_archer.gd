extends Enemy
class_name EnemyArcher

@export var projectile_scene: PackedScene
@export var attack_distance: float = 350.0
@export var retreat_distance: float = 200.0

func _ready() -> void:
	max_health = 25.0
	move_speed = 90.0
	damage = 8.0
	attack_cooldown = 2.0
	xp_value = 2
	
	super._ready()

func _physics_process(delta: float) -> void:
	if not player:
		return
	
	var distance = global_position.distance_to(player.global_position)
	
	# Keep distance from player
	if distance < retreat_distance:
		# Move away
		var direction = (global_position - player.global_position).normalized()
		velocity = direction * move_speed
	elif distance > attack_distance:
		# Move closer
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * move_speed * 0.7
	else:
		# Stay at optimal range
		velocity = Vector2.ZERO
	
	move_and_slide()
	
	# Attack if in range
	if attack_timer > 0:
		attack_timer -= delta
	else:
		if distance < attack_distance:
			attack_player()
			attack_timer = attack_cooldown

func attack_player() -> void:
	if not player or not projectile_scene:
		return
	
	# Fire projectile at player
	var projectile = projectile_scene.instantiate() as Projectile
	if not projectile:
		return
	
	var direction = (player.global_position - global_position).normalized()
	
	projectile.global_position = global_position
	projectile.damage = damage
	projectile.speed = 250.0
	projectile.collision_layer = 0
	projectile.collision_mask = 1  # Hit player only
	projectile.set_direction(direction)
	
	get_tree().root.add_child(projectile)
