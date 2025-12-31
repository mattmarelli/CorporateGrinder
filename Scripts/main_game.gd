extends Node2D

var laborer_scene = preload("res://Scenes/laborer.tscn")
var manager_scene = preload("res://Scenes/manager.tscn")
var executive_scene = preload("res://Scenes/executive.tscn")
var dungeon_spawner_scene = preload("res://Scenes/dungeon_spawner.tscn")
var character_save_slot = null
var character_save: SavedCharacter = null


func _ready():
	var screen_rect = get_viewport().get_visible_rect()
	var screen_width = screen_rect.size.x
	var player = null
	if character_save.character_type.to_lower() == "laborer":
		player = laborer_scene.instantiate()
	elif character_save.character_type.to_lower() == "manager":
		player = manager_scene.instantiate()
	elif character_save.character_type.to_lower() == "executive":
		player = executive_scene.instantiate()

	player.character_type = character_save.character_type
	player.name = "player"
	add_child(player)

	var dungeon_spawner = dungeon_spawner_scene.instantiate()

	dungeon_spawner.position = Vector2(screen_width / 2, 50)
	add_child(dungeon_spawner)
