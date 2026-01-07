extends Resource
class_name CharacterData

@export var character_id: String = ""
@export var character_name: String = ""
@export var description: String = ""
@export var icon_path: String = ""

# Starting stats
@export var base_health: float = 100.0
@export var base_armor: float = 0.0
@export var base_move_speed: float = 200.0
@export var base_might: float = 1.0
@export var base_area: float = 1.0
@export var base_cooldown: float = 1.0
@export var base_regen: float = 0.0
@export var base_faith: float = 0.0

# Starting weapon scene
@export var starting_weapon: PackedScene

# Unlock requirements
@export var unlock_cost: int = 0
@export var unlock_requirement_text: String = ""

func apply_to_player(player: Player) -> void:
	if not player:
		return
	
	player.max_health = base_health
	player.current_health = base_health
	player.armor = base_armor
	player.move_speed = base_move_speed
	player.might = base_might
	player.area = base_area
	player.cooldown_reduction = base_cooldown
	player.health_regen = base_regen
	player.faith = base_faith
