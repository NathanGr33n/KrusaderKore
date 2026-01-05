extends Projectile
class_name BoomerangProjectile

var origin_position: Vector2
var max_distance: float = 300.0
var return_speed_multiplier: float = 1.5
var is_returning: bool = false
var distance_traveled: float = 0.0

func set_origin(pos: Vector2) -> void:
	origin_position = pos

func _process(delta: float) -> void:
	current_lifetime += delta
	
	if current_lifetime >= lifetime:
		queue_free()
		return
	
	var move_distance = speed * delta
	
	# Check if should start returning
	if not is_returning:
		distance_traveled += move_distance
		if distance_traveled >= max_distance:
			is_returning = true
	
	if is_returning:
		# Return to origin
		var to_origin = (origin_position - global_position).normalized()
		direction = to_origin
		global_position += direction * speed * return_speed_multiplier * delta
		
		# Destroy when back at origin
		if global_position.distance_to(origin_position) < 20.0:
			queue_free()
	else:
		# Move outward
		global_position += direction * move_distance
	
	rotation = direction.angle()
