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
@onready var selected_character_texture_rect = $SelectCharacterCanvasLayer/SelectCharacterPanelContainer/SelectCharacterVBoxContainer/HBoxContainer/SelectedCharacterTextureRect
@onready var selected_character_label = $SelectCharacterCanvasLayer/SelectCharacterPanelContainer/SelectCharacterVBoxContainer/HBoxContainer/SelectedCharacterLabel



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

func get_character_image(character_type):
	var image = null

	if character_type == "Laborer":
		image = load("res://Assets/Laborer_Man.png")
	if character_type == "Manager":
		image = load("res://Assets/Manager_Man.png")
	if character_type == "Executive":
		image = load("res://Assets/CEO_Man.png")

	return image

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

	button_to_set_up.icon = get_character_image(character_save.character_type)

	button_to_set_up.text = (
		character_save.character_name
		+ "\n"
		+ str(character_save.character_type)
		+ " Level: "
		+ str(character_save.character_level)
	)
	
	button_to_set_up.pressed.connect(select_character.bind(button_to_set_up))
	button_to_set_up.show()


func show_create_character_layer():
	create_character_canvas_layer.show()


func start_game():
	if selected_character == null:
		return
	print("Game is started")
	var main_game = main_game_scene.instantiate()
	main_game.character_save_slot = selected_character_save_spot
	main_game.character_save = selected_character
	get_tree().root.add_child(main_game)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = main_game


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

func select_character(button: Button):
	if button == select_character_one_button:
		selected_character = characters[0]
		selected_character_save_spot = 0
	elif button == select_character_two_button:
		selected_character = characters[1]
		selected_character_save_spot = 1
	elif button == select_character_three_button:
		selected_character = characters[2]
		selected_character_save_spot = 2
	elif button == select_character_four_button:
		selected_character = characters[3]
		selected_character_save_spot = 3
	elif button == select_character_five_button:
		selected_character = characters[4]
		selected_character_save_spot = 4

	var image = get_character_image(selected_character.character_type)
	selected_character_texture_rect.texture = image
	selected_character_label.text = "Selected Character: " + selected_character.character_name
