extends Node

var enemy_spawner_script = preload("res://Scripts/enemy_spawner.gd")
var enemy_spawner = null
var enemy_spawner_timer = Timer.new()


func _ready():
	enemy_spawner = enemy_spawner_script.new()
	get_tree().root.add_child(enemy_spawner)
	enemy_spawner_timer.name = "enemy_spawn_timer"
	get_tree().root.add_child(enemy_spawner_timer)
	enemy_spawner_timer.timeout.connect(enemy_spawner.spawn_enemies)


func create_dungeon_and_set_scene():
	print("This is being called!")
	var tree = get_tree()
	var old_scene = tree.current_scene
	var player = tree.get_root().find_child("player", true, false)
	var dungeon_node = Node2D.new()
	dungeon_node.name = "dungeon"
	player.reparent(dungeon_node)
	tree.root.add_child(dungeon_node)
	tree.current_scene = dungeon_node

	old_scene.queue_free()
	start_enemy_spawn()


func start_enemy_spawn():
	print("THIS IS CALLED!!!")
	enemy_spawner_timer.wait_time = 10.0
	enemy_spawner_timer.one_shot = false
	enemy_spawner_timer.start()
