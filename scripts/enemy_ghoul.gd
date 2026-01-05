extends Enemy
class_name EnemyGhoul

@export var regen_rate: float = 2.0

func _ready() -> void:
	max_health = 60.0
	move_speed = 85.0
	damage = 7.0
	attack_cooldown = 1.0
	xp_value = 4
	
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	# Regenerate health
	if current_health < max_health:
		current_health = min(current_health + regen_rate * delta, max_health)
