extends CharacterBody2D
class_name Player

## Player stats
@export var max_health: float = 100.0
@export var move_speed: float = 200.0
@export var armor: float = 0.0

var current_health: float
var level: int = 1
var experience: int = 0
var experience_to_next_level: int = 5

## Stats modifiers
var might: float = 1.0  # Damage multiplier
var area: float = 1.0   # Area multiplier
var cooldown_reduction: float = 1.0
var faith: float = 0.0  # Special scaling stat

signal health_changed(new_health: float, max_health: float)
signal level_up(new_level: int)
signal experience_gained(exp: int, total_exp: int, exp_to_next: int)
signal died

func _ready() -> void:
	current_health = max_health
	add_to_group("player")
	health_changed.emit(current_health, max_health)

func _physics_process(delta: float) -> void:
	_handle_movement(delta)

func _handle_movement(delta: float) -> void:
	var input_vector := Vector2.ZERO
	
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		velocity = input_vector * move_speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func take_damage(amount: float) -> void:
	var actual_damage = max(amount - armor, 0)
	current_health -= actual_damage
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		die()

func heal(amount: float) -> void:
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)

func add_experience(amount: int) -> void:
	experience += amount
	experience_gained.emit(amount, experience, experience_to_next_level)
	
	while experience >= experience_to_next_level:
		experience -= experience_to_next_level
		level_up_player()

func level_up_player() -> void:
	level += 1
	experience_to_next_level = int(experience_to_next_level * 1.2)
	level_up.emit(level)

func die() -> void:
	died.emit()
	# Disable player
	set_physics_process(false)
	set_process(false)
