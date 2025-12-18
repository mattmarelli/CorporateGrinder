extends Node2D
class_name BaseWeapon

@onready var weapon_sprite = $WeaponSprite

var sprite_down = null
var sprite_up = null
var sprite_left = load("res://Assets/Weapons/FirstSwordLeft.png")
var sprite_right = load("res://Assets/Weapons/FirstSword.png")
var type = null
var sprite_offset_x = 5
var sprite_offset_y = 5

func update_sprite(direction):
	if direction == "up":
		weapon_sprite.texture = sprite_up
	elif direction == "down":
		weapon_sprite.texture = sprite_down
	elif direction == "right":
		weapon_sprite.texture = sprite_right
		weapon_sprite.offset = Vector2(sprite_offset_x, -sprite_offset_y)
	elif direction == "left":
		weapon_sprite.texture = sprite_left
		weapon_sprite.offset = Vector2(-sprite_offset_x - 3, -sprite_offset_y)

func attack():
	pass
