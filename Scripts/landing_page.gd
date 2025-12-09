extends Node2D

@onready var create_character_canvas_layer = $CreateCharacterCanvasLayer
@onready
var select_laborer_button = $CreateCharacterCanvasLayer/CreateCharacterPanelContainer/MarginContainer/VBoxContainer/CreateCharacterGridContainer/SelectLaborerButton
@onready
var select_manager_button = $CreateCharacterCanvasLayer/CreateCharacterPanelContainer/MarginContainer/VBoxContainer/CreateCharacterGridContainer/SelectManagerButton
@onready
var select_executive_button = $CreateCharacterCanvasLayer/CreateCharacterPanelContainer/MarginContainer/VBoxContainer/CreateCharacterGridContainer/SelectExecutiveButton
@onready
var final_create_character_button = $CreateCharacterCanvasLayer/CreateCharacterPanelContainer/MarginContainer/VBoxContainer/ShowCharacterStatsPanelContainer/VBoxContainer/FinalCreateCharacterButton
@onready
var create_character_description_label = $CreateCharacterCanvasLayer/CreateCharacterPanelContainer/MarginContainer/VBoxContainer/ShowCharacterStatsPanelContainer/VBoxContainer/CharacterDescriptionLabel
@onready
var cancel_create_character_button = $CreateCharacterCanvasLayer/CreateCharacterPanelContainer/MarginContainer/VBoxContainer/ShowCharacterStatsPanelContainer/VBoxContainer/CancelCreateCharacterButton
@onready
var create_character_name = $CreateCharacterCanvasLayer/CreateCharacterPanelContainer/MarginContainer/VBoxContainer/ShowCharacterStatsPanelContainer/VBoxContainer/CreateCharacterNameLineEdit
@onready
var select_character_one_button = $SelectCharacterCanvasLayer/SelectCharacterPanelContainer/SelectCharacterVBoxContainer/SelectCharacterOneButton
@onready
var select_character_two_button = $SelectCharacterCanvasLayer/SelectCharacterPanelContainer/SelectCharacterVBoxContainer/SelectCharacterTwoButton
@onready
var select_character_three_button = $SelectCharacterCanvasLayer/SelectCharacterPanelContainer/SelectCharacterVBoxContainer/SelectCharacterThreeButton
@onready
var select_character_four_button = $SelectCharacterCanvasLayer/SelectCharacterPanelContainer/SelectCharacterVBoxContainer/SelectCharacterFourButton
@onready
var select_character_five_button = $SelectCharacterCanvasLayer/SelectCharacterPanelContainer/SelectCharacterVBoxContainer/SelectCharacterFiveButton

var main_game_scene = preload("res://Scenes/main_game.tscn")
var selected_character: SavedCharacter = null
var selected_character_save_spot = null
var creating_character = ""
var characters = []
var saver_loader: SaverLoader = null


func _ready():
	saver_loader = SaverLoader.new()
	create_character_canvas_layer.hide()
	saver_loader.initial_game_save()
	characters = saver_loader.load_game()
	select_character_one_button.hide()
	select_character_two_button.hide()
	select_character_three_button.hide()
	select_character_four_button.hide()
	select_character_five_button.hide()
	set_up_character_select_buttons()


func set_up_character_select_buttons():
	var character_count = 0

	for character in characters:
		character_count += 1
		set_up_character_select_button(character, character_count)


func set_up_character_select_button(character_save: SavedCharacter, character_slot: int):
	var button_to_set_up = null

	if character_slot == 1:
		button_to_set_up = select_character_one_button
	if character_slot == 2:
		button_to_set_up = select_character_two_button
	if character_slot == 3:
		button_to_set_up = select_character_three_button
	if character_slot == 4:
		button_to_set_up = select_character_four_button
	if character_slot == 5:
		button_to_set_up = select_character_five_button

	if character_save.character_type == "Laborer":
		button_to_set_up.icon = load("res://Assets/Laborer_Man.png")
	if character_save.character_type == "Manager":
		button_to_set_up.icon = load("res://Assets/Manager_Man.png")
	if character_save.character_type == "Executive":
		button_to_set_up.icon = load("res://Assets/CEO_Man.png")

	button_to_set_up.text = (
		character_save.character_name
		+ "\n"
		+ str(character_save.character_type)
		+ " Level: "
		+ str(character_save.character_level)
	)
	button_to_set_up.show()


func show_create_character_layer():
	create_character_canvas_layer.show()


func start_game():
	print("Game is started")
	get_tree().change_scene_to_packed(main_game_scene)


func cancel_create_character():
	final_create_character_button.text = "Create Character"
	create_character_description_label.text = ""
	create_character_canvas_layer.hide()
	creating_character = ""
	create_character_name.text = ""


func select_laborer():
	final_create_character_button.text = "Create Laborer"
	create_character_description_label.text = "The Laborer is able to survive the Corporate Grind through strength and willpower"
	creating_character = "Laborer"


func select_manager():
	final_create_character_button.text = "Create Manager"
	create_character_description_label.text = "The Manager is able to survive the Corporate Grind by utilizing underlings to do thier bidding"
	creating_character = "Manager"


func select_executive():
	final_create_character_button.text = "Create Executive"
	create_character_description_label.text = "The Executive is able to survive the Corporate Grind by cunning and ruthlessness"
	creating_character = "Executive"


func create_character():
	if create_character_name.text == "" or creating_character == "":
		return

	var character_name = create_character_name.text
	var character_type = creating_character

	saver_loader.save_new_character(character_type, character_name)

	# clean up character creating
	cancel_create_character()

	characters = saver_loader.load_game()
	set_up_character_select_buttons()
