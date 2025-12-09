extends Node2D

@onready var dungeon_body = $DungeonSpawnerStaticBody
@onready var spawn_dungeon_canvas_layer = $DungeonSpawnerCreateDungeonCanvasLayer
@onready var dungeon_spawner_interation_panel = $DungeonSpawnerInteractPanelContainer
var dungeon_spawner_logic_script = preload("res://Scripts/dungeon_spawner_logic.gd")
var dungeon_spawner_logic = null

var player_in_interactable_area = false


func _ready():
	dungeon_spawner_interation_panel.hide()
	spawn_dungeon_canvas_layer.hide()
	dungeon_spawner_logic = dungeon_spawner_logic_script.new()
	add_child(dungeon_spawner_logic)


func _unhandled_input(_event):
	var interact = Input.is_action_pressed("interact")

	if player_in_interactable_area and interact:
		interact_with_dungeon_spawner()


func player_entered_area(area):
	if area == dungeon_body:
		return

	dungeon_spawner_interation_panel.show()
	player_in_interactable_area = true


func player_exited_area(_area):
	dungeon_spawner_interation_panel.hide()
	spawn_dungeon_canvas_layer.hide()
	player_in_interactable_area = false


func interact_with_dungeon_spawner():
	dungeon_spawner_interation_panel.hide()
	spawn_dungeon_canvas_layer.show()


func create_dungon_clicked():
	dungeon_spawner_logic.create_dungeon_and_set_scene()
