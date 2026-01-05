extends Enemy
class_name EnemyElite

func _ready() -> void:
	# Elite has boosted stats
	max_health = 100.0
	move_speed = 80.0
	damage = 10.0
	xp_value = 5
	
	super._ready()
