extends Node


func _ready():
	randomize()


func spawn_loot(enemy):
	var spawn_item_float = randf()
	var spawn_item_amount_float = randf()
	var spawn_share_float = randf()

	if spawn_item_float <= 0.1:
		var spawn_item_amount = 1
		if spawn_item_amount_float <= 0.5:
			spawn_item_amount = 2
		elif spawn_item_amount_float <= 0.1:
			spawn_item_amount = 3

		for i in spawn_item_amount:
			ItemSpawner.spawn_item(enemy)

	if spawn_share_float <= 0.05:
		ShareSpawner.spawn_share(enemy)
