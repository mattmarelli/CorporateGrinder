extends CharacterBody2D
class_name BasePlayer

# TODO move this weapon spawn into a weapon spawner script!
var weapon_scene = preload("res://Scenes/weapon.tscn")

@onready var player_cam = $PlayerCamera
@onready var attack_area = $AttackArea
@export var speed = 400
@onready var player_collision_shape = $PlayerCollisionShape
@onready var right_hand_node = $RightHandNode
@onready var animated_upper_sprite = $AnimatedUpperSprite
@onready var animated_lower_sprite = $AnimatedLowerSprite


var character_type = ""
var max_zoom = 1.0
var min_zoom = 0.5
var camera_zoom_amount = 0.1
var walking_to_position = Vector2.ZERO
var last_position = Vector2.ZERO
var player_can_move = false

var weapon = null
var base_damage = 5.0

var idle_upper_animation_string = ""
var idle_lower_animation_string = ""
var walk_up_animation_string = ""
var walk_down_animation_string = ""
var walk_left_animation_string = ""
var walk_right_animation_string = ""

var idle_right_hand_position = Vector2.ZERO

var right_hand_offsets_facing_sideways = {
	0: Vector2(3, 15),
	1: Vector2(10, 15),
	2: Vector2(21, 15),
	3: Vector2(10, 15),
	4: Vector2(3, 15),
	5: Vector2(-5, 15),
	6: Vector2(-15, 15),
	7: Vector2(-5, 15),
	8: Vector2(3, 15),
}


func _ready():
	player_cam.zoom = Vector2(0.5, 0.5)
	attack_area.monitoring = false
	attack_area.body_entered.connect(_on_attack_area_entered)
	idle_upper_animation_string = "idle_down"
	idle_lower_animation_string = "idle_down"
	walk_up_animation_string = "walk_up"
	walk_down_animation_string = "walk_down"
	walk_right_animation_string = "walk_right"
	walk_left_animation_string = "walk_left"
	animated_upper_sprite.play(idle_upper_animation_string)
	animated_lower_sprite.play(idle_lower_animation_string)
	
	await get_tree().create_timer(0.1).timeout
	player_can_move = true

	# Spawn player with weapon but will remove this from code eventually
	weapon = weapon_scene.instantiate()
	weapon.position = right_hand_offsets_facing_sideways[0]
	add_child(weapon)


func get_input():
	var distance_from_walking_position = abs(walking_to_position - self.global_position)
	var is_character_blocked_from_moving = abs(last_position - self.global_position) < Vector2(1.0, 1.0)
	if distance_from_walking_position < Vector2(3.0, 3.0):
		walking_to_position = Vector2.ZERO
	elif is_character_blocked_from_moving:
		walking_to_position = Vector2.ZERO

	var input_direction = Vector2.ZERO
	var player_click = Input.is_action_just_pressed("click") or Input.is_action_pressed("click")
	if player_click:
		var click_position = get_global_mouse_position()
		input_direction = (click_position - self.global_position).normalized()
		walking_to_position = click_position
	elif walking_to_position != Vector2.ZERO:
		input_direction = (walking_to_position - self.global_position).normalized()

	velocity = input_direction * speed
	last_position = self.global_position
	update_player_sprite_direction(input_direction)

func update_player_sprite_direction(input_direction: Vector2):
	if input_direction == Vector2.ZERO:
		animated_upper_sprite.play(idle_upper_animation_string)
		animated_lower_sprite.play(idle_lower_animation_string)
		right_hand_node.position = idle_right_hand_position
		return
	
	var direction = null

	if abs(input_direction.x) > abs(input_direction.y):
		if input_direction.x > 0:
			direction = "right"
			idle_right_hand_position = right_hand_offsets_facing_sideways[0]
		else:
			direction = "left"
			idle_right_hand_position = right_hand_offsets_facing_sideways[0]
	else:
		if input_direction.y > 0:
			direction = "down"
		else:
			direction = "up"

	animated_upper_sprite.play("walk_" + direction)
	animated_lower_sprite.play("walk_" + direction)
	idle_upper_animation_string = "idle_" + direction
	idle_lower_animation_string = "idle_" + direction

	if weapon:
		weapon.update_sprite(direction)


func _physics_process(_delta):
	if player_can_move:
		get_input()
		move_and_slide()


func _unhandled_input(_event):
	var scroll_up = Input.is_action_pressed("wheel_scroll_up")
	var scroll_down = Input.is_action_pressed("wheel_scroll_down")
	var attack_pressed = Input.is_action_just_pressed("right_click")

	if scroll_up:
		if player_cam.zoom < Vector2(max_zoom, max_zoom):
			player_cam.zoom = player_cam.zoom + Vector2(camera_zoom_amount, camera_zoom_amount)

	if scroll_down:
		if player_cam.zoom > Vector2(min_zoom, min_zoom):
			player_cam.zoom = player_cam.zoom - Vector2(camera_zoom_amount, camera_zoom_amount)

	if attack_pressed:
		attack()


func _process(_delta):
	var frame_number = animated_upper_sprite.frame
	var direction = null

	if animated_upper_sprite.animation == "walk_right":
		right_hand_node.position = right_hand_offsets_facing_sideways[frame_number]
		direction = "right"
	elif animated_upper_sprite.animation == "walk_left":
		right_hand_node.position = right_hand_offsets_facing_sideways[frame_number]
		direction = "left"

	if weapon:
		weapon.position = right_hand_node.position
		
		if direction in ["right", "down"]:
			weapon.z_index = 10
		elif direction in ["left", "up"]:
			weapon.z_index = -10

func attack():
	if weapon and weapon.type != "meele":
		weapon.attack()
	else:
		attack_area.monitoring = true
		await get_tree().create_timer(0.1).timeout
		attack_area.monitoring = false


func _on_attack_area_entered(body):
	var enemy = body
	if enemy.is_in_group("enemy") and enemy.has_method("take_damage"):
		enemy.take_damage(base_damage)
