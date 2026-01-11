extends Node

var weapon_scene = preload("res://Scenes/weapon.tscn")


func _ready():
	randomize()


func spawn_item(enemy):
	var item_number = randf()

	if item_number <= 1.0:
		var weapon = weapon_scene.instantiate()
		weapon.is_on_ground = true
		weapon.global_position = enemy.global_position
		get_tree().current_scene.call_deferred("add_child", weapon)
