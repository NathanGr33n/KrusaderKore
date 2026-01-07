extends Node
class_name MetaData

const SAVE_PATH = "user://save_data.json"

var unlocked_characters: Array[String] = ["templar"]  # Start with Templar unlocked
var unlocked_weapons: Array[String] = []
var unlocked_relics: Array[String] = []

var total_kills: int = 0
var total_runs: int = 0
var total_time_survived: float = 0.0
var best_time: float = 0.0
var highest_level: int = 1

var meta_currency: int = 0  # Souls/Crusader Marks earned

var persistent_upgrades: Dictionary = {
	"max_health_bonus": 0,
	"starting_armor": 0,
	"starting_damage": 0,
	"starting_speed": 0,
	"xp_multiplier": 0
}

func save_data() -> void:
	var data = {
		"unlocked_characters": unlocked_characters,
		"unlocked_weapons": unlocked_weapons,
		"unlocked_relics": unlocked_relics,
		"total_kills": total_kills,
		"total_runs": total_runs,
		"total_time_survived": total_time_survived,
		"best_time": best_time,
		"highest_level": highest_level,
		"meta_currency": meta_currency,
		"persistent_upgrades": persistent_upgrades
	}
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		return
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error == OK:
		var data = json.data
		if data is Dictionary:
			unlocked_characters = data.get("unlocked_characters", ["templar"])
			unlocked_weapons = data.get("unlocked_weapons", [])
			unlocked_relics = data.get("unlocked_relics", [])
			total_kills = data.get("total_kills", 0)
			total_runs = data.get("total_runs", 0)
			total_time_survived = data.get("total_time_survived", 0.0)
			best_time = data.get("best_time", 0.0)
			highest_level = data.get("highest_level", 1)
			meta_currency = data.get("meta_currency", 0)
			persistent_upgrades = data.get("persistent_upgrades", persistent_upgrades)

func add_run_stats(kills: int, time: float, level: int, currency_earned: int) -> void:
	total_kills += kills
	total_runs += 1
	total_time_survived += time
	
	if time > best_time:
		best_time = time
	
	if level > highest_level:
		highest_level = level
	
	meta_currency += currency_earned
	
	save_data()

func unlock_character(character_id: String) -> void:
	if not unlocked_characters.has(character_id):
		unlocked_characters.append(character_id)
		save_data()

func is_character_unlocked(character_id: String) -> bool:
	return unlocked_characters.has(character_id)

func purchase_persistent_upgrade(upgrade_id: String, cost: int) -> bool:
	if meta_currency >= cost:
		meta_currency -= cost
		persistent_upgrades[upgrade_id] = persistent_upgrades.get(upgrade_id, 0) + 1
		save_data()
		return true
	return false
