extends Enemy
class_name EnemyMamluk

func _ready() -> void:
	# Tanky, slow enemy
	max_health = 150.0
	move_speed = 60.0
	damage = 15.0
	attack_cooldown = 1.5
	xp_value = 8
	
	super._ready()
