extends Area2D
class_name Projectile

@export var damage: float = 10.0
@export var speed: float = 300.0
@export var lifetime: float = 5.0
@export var pierce_count: int = 1
@export var is_homing: bool = false
@export var homing_strength: float = 200.0

var direction: Vector2 = Vector2.RIGHT
var current_lifetime: float = 0.0
var pierced_enemies: int = 0
var hit_enemies: Array[Enemy] = []
var target: Node2D = null

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	current_lifetime += delta
	
	if current_lifetime >= lifetime:
		queue_free()
		return
	
	# Homing behavior
	if is_homing and target and is_instance_valid(target):
		var to_target = (target.global_position - global_position).normalized()
		direction = direction.lerp(to_target, homing_strength * delta / speed).normalized()
	
	# Move projectile
	global_position += direction * speed * delta

func set_direction(dir: Vector2) -> void:
	direction = dir.normalized()
	rotation = direction.angle()

func set_target(t: Node2D) -> void:
	target = t

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		_hit_enemy(body)

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Enemy:
		_hit_enemy(area.get_parent())

func _hit_enemy(enemy: Enemy) -> void:
	if hit_enemies.has(enemy):
		return
	
	hit_enemies.append(enemy)
	enemy.take_damage(damage)
	pierced_enemies += 1
	
	if pierced_enemies >= pierce_count:
		queue_free()
