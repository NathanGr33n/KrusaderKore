extends Area2D
class_name XPGem

@export var xp_amount: int = 1
@export var pickup_range: float = 100.0
@export var move_speed: float = 300.0

var player: Player
var is_moving_to_player: bool = false

func _ready() -> void:
	add_to_group("xp_gems")
	body_entered.connect(_on_body_entered)
	
	# Find player
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0] as Player

func _process(delta: float) -> void:
	if not player:
		return
	
	var distance = global_position.distance_to(player.global_position)
	
	# Start moving toward player when in range
	if distance < pickup_range:
		is_moving_to_player = true
	
	if is_moving_to_player:
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * move_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not is_queued_for_deletion():
		body.add_experience(xp_amount)
		queue_free()
