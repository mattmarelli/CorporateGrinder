extends BaseItem
class_name BaseWeapon

@onready var weapon_sprite = $WeaponSprite
@onready var name_container = $NameContainer
@onready var name_label = $NameContainer/NameLabel
@onready var weapon_area = $WeaponArea
@onready var pickup_collision_shape = $PickupArea/PickupCollisionShape
@export var damage = 5

var sprite_down = load("res://Assets/Weapons/FirstSwordDown.png")
var sprite_up = null
var sprite_left = load("res://Assets/Weapons/FirstSwordLeft.png")
var sprite_right = load("res://Assets/Weapons/FirstSword.png")
var type = "meele"
var sprite_offset_x = 5
var sprite_offset_y = 5

var player_in_pickup_range = false


func _ready():
	item_name = "Base Weapon"
	name_label.text = item_name
	if is_on_ground:
		self.z_index = -100
		name_container.visible = true


func update_sprite(direction):
	if direction == "up":
		weapon_sprite.texture = sprite_up
	elif direction == "down":
		weapon_sprite.texture = sprite_down
		weapon_sprite.offset = Vector2(-sprite_offset_x - 3, -sprite_offset_y)
	elif direction == "right":
		weapon_sprite.texture = sprite_right
		weapon_sprite.offset = Vector2(sprite_offset_x, -sprite_offset_y)
	elif direction == "left":
		weapon_sprite.texture = sprite_left
		weapon_sprite.offset = Vector2(-sprite_offset_x - 3, -sprite_offset_y)


func attack():
	pass


func player_entered_pickup_area(area):
	if area == weapon_area:
		return

	player_in_pickup_range = true


func player_exited_area(_area):
	player_in_pickup_range = false


func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		queue_free()
