extends Node2D

var player_scene = preload("res://Scenes/player.tscn")
var dungeon_spawner_scene = preload("res://Scenes/dungeon_spawner.tscn")
var character_save_slot = null
var character_save:SavedCharacter = null

func _ready():
	var screen_rect = get_viewport().get_visible_rect()
	var screen_width = screen_rect.size.x

	var player = player_scene.instantiate()
	player.character_type = character_save.character_type
	player.name = "player"
	add_child(player)

	var dungeon_spawner = dungeon_spawner_scene.instantiate()

	dungeon_spawner.position = Vector2(screen_width, 50)
	add_child(dungeon_spawner)
