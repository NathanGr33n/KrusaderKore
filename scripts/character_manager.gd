extends Node
class_name CharacterManager

var available_characters: Array[CharacterData] = []
var selected_character: CharacterData

func _ready() -> void:
	_initialize_characters()

func _initialize_characters() -> void:
	# Templar Knight - balanced starter
	var templar = CharacterData.new()
	templar.character_id = "templar"
	templar.character_name = "Templar Knight"
	templar.description = "Balanced warrior with strong melee capabilities"
	templar.base_health = 100.0
	templar.base_armor = 2.0
	templar.base_move_speed = 200.0
	templar.base_might = 1.1
	templar.starting_weapon = preload("res://scenes/player.tscn")  # Has longsword
	templar.unlock_cost = 0
	available_characters.append(templar)
	
	# Hospitaller - defensive healer
	var hospitaller = CharacterData.new()
	hospitaller.character_id = "hospitaller"
	hospitaller.character_name = "Hospitaller"
	hospitaller.description = "Defensive healer with high HP and regeneration"
	hospitaller.base_health = 150.0
	hospitaller.base_armor = 5.0
	hospitaller.base_move_speed = 180.0
	hospitaller.base_regen = 1.0
	hospitaller.base_might = 0.9
	hospitaller.starting_weapon = preload("res://scenes/player.tscn")
	hospitaller.unlock_cost = 50
	hospitaller.unlock_requirement_text = "Survive 10 minutes"
	available_characters.append(hospitaller)
	
	# Pilgrim Mystic - faith-based AoE
	var mystic = CharacterData.new()
	mystic.character_id = "mystic"
	mystic.character_name = "Pilgrim Mystic"
	mystic.description = "Faith-focused mystic with large area attacks"
	mystic.base_health = 80.0
	mystic.base_armor = 0.0
	mystic.base_move_speed = 210.0
	mystic.base_area = 1.3
	mystic.base_faith = 0.5
	mystic.base_cooldown = 1.1
	mystic.starting_weapon = preload("res://scenes/player.tscn")
	mystic.unlock_cost = 100
	mystic.unlock_requirement_text = "Reach level 15"
	available_characters.append(mystic)

func get_character_by_id(character_id: String) -> CharacterData:
	for character in available_characters:
		if character.character_id == character_id:
			return character
	return null

func select_character(character_id: String) -> void:
	selected_character = get_character_by_id(character_id)
