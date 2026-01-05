extends Enemy
class_name EnemyRaider

func _ready() -> void:
	# Fast, low health enemy
	max_health = 20.0
	move_speed = 150.0
	damage = 6.0
	attack_cooldown = 0.7
	xp_value = 2
	
	super._ready()
