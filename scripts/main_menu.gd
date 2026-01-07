extends Node

@onready var character_selection: CharacterSelectionUI = $CharacterSelectionUI
@onready var upgrades_shop: UpgradesShopUI = $UpgradesShopUI
@onready var character_manager: CharacterManager = $CharacterManager
@onready var meta_data: MetaData = $MetaData

const GAME_SCENE = "res://scenes/main.tscn"

func _ready() -> void:
	# Load meta data
	if meta_data:
		meta_data.load_data()
	
	# Initialize UI
	if character_selection and character_manager and meta_data:
		character_selection.initialize(character_manager, meta_data)
		character_selection.character_selected.connect(_on_character_selected)
		character_selection.upgrades_requested.connect(_on_upgrades_requested)
	
	if upgrades_shop and meta_data:
		upgrades_shop.initialize(meta_data)
		upgrades_shop.back_requested.connect(_on_upgrades_back)
		upgrades_shop.hide()

func _on_character_selected(character_data: CharacterData) -> void:
	# Store selected character in a global/autoload or pass it to the game scene
	# For now, we'll just load the game scene
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_upgrades_requested() -> void:
	if character_selection:
		character_selection.hide()
	if upgrades_shop:
		upgrades_shop.show()

func _on_upgrades_back() -> void:
	if upgrades_shop:
		upgrades_shop.hide()
	if character_selection:
		character_selection.show()
