extends Node

var meele_enemy_scene = preload("res://Scenes/meele_enemy.tscn")
var meele_irs_enemy_scene = preload("res://Scenes/meele_irs_agent.tscn")

var enemy_level
var enemy_spawns


func init(_enemy_level = 1, _enemy_spawns = 3):
	enemy_level = _enemy_level
	enemy_spawns = _enemy_spawns


func spawn_enemies():
	var meele_enemy = meele_irs_enemy_scene.instantiate()
	meele_enemy.init(10.0)
	add_child(meele_enemy)
