class_name SaverLoader
extends Node

func save_game():
	pass

func initial_game_save():
	if not FileAccess.file_exists("user://savegame.tres"):
		var saved_game = SavedGame.new()
		ResourceSaver.save(saved_game, "user://savegame.tres")

func load_game() -> Array[SavedCharacter]:
	var saved_game:SavedGame = load("user://savegame.tres")
	var characters = [] as Array[SavedCharacter]

	if saved_game.character_slot_1 != null:
		characters.append(saved_game.character_slot_1 as SavedCharacter)
	if saved_game.character_slot_2 != null:
		characters.append(saved_game.character_slot_2 as SavedCharacter)
	if saved_game.character_slot_3 != null:
		characters.append(saved_game.character_slot_3 as SavedCharacter)
	if saved_game.character_slot_4 != null:
		characters.append(saved_game.character_slot_4 as SavedCharacter)
	if saved_game.character_slot_5 != null:
		characters.append(saved_game.character_slot_5 as SavedCharacter)

	return characters

func save_new_character(character_type, character_name):
	var saved_game:SavedGame = load("user://savegame.tres")
	var new_character = SavedCharacter.new()
	new_character.character_type = character_type
	new_character.character_name = character_name

	if saved_game.character_slot_1 == null:
		saved_game.character_slot_1 = new_character
	elif saved_game.character_slot_2 == null:
		saved_game.character_slot_2 = new_character
	elif saved_game.character_slot_3 == null:
		saved_game.character_slot_3 = new_character
	elif saved_game.character_slot_4 == null:
		saved_game.character_slot_4 = new_character
	elif saved_game.character_slot_5 == null:
		saved_game.character_slot_5 = new_character

	ResourceSaver.save(saved_game, "user://savegame.tres")
