extends CharacterBody2D
class_name Enemy

## Enemy stats
@export var max_health: float = 30.0
@export var move_speed: float = 100.0
@export var damage: float = 5.0
@export var attack_cooldown: float = 1.0
@export var xp_value: int = 1

var current_health: float
var player: Player
var attack_timer: float = 0.0

signal died(position: Vector2, xp_value: int)

func _ready() -> void:
	current_health = max_health
	add_to_group("enemies")
	
	# Find player
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0] as Player

func _physics_process(delta: float) -> void:
	if not player:
		return
	
	# Chase player
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()
	
	# Attack player if in range
	if attack_timer > 0:
		attack_timer -= delta
	else:
		var distance = global_position.distance_to(player.global_position)
		if distance < 30.0:  # Attack range
			attack_player()
			attack_timer = attack_cooldown

func attack_player() -> void:
	if player:
		player.take_damage(damage)

func take_damage(amount: float) -> void:
	current_health -= amount
	
	if current_health <= 0:
		die()

func die() -> void:
	died.emit(global_position, xp_value)
	queue_free()
