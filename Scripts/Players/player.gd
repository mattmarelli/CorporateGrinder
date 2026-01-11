extends CharacterBody2D
class_name BasePlayer

# TODO move this weapon spawn into a weapon spawner script!
var weapon_scene = preload("res://Scenes/weapon.tscn")

@onready var player_cam = $PlayerCamera
@onready var attack_area = $AttackArea
@onready var attack_collision = $AttackArea/AttackCollision
@export var speed = 400
@onready var player_collision_shape = $PlayerCollisionShape
@onready var right_hand_node = $RightHandNode
@onready var animated_upper_sprite = $AnimatedUpperSprite
@onready var animated_lower_sprite = $AnimatedLowerSprite
@onready var attack_area_display = $AttackArea/AttackAreaDisplay

var character_type = ""
var max_zoom = 1.0
var min_zoom = 0.5
var camera_zoom_amount = 0.1
var walking_to_position = Vector2.ZERO
var last_position = Vector2.ZERO
var current_direction = "down"
var need_to_sync_walking_animation = false
var player_can_move = false

var weapon = null
var base_damage = 5.0
var is_basic_attacking = false

var idle_upper_animation_string = "idle_down"
var idle_lower_animation_string = "idle_down"

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

var right_hand_offsets_attacking_right = {
	0: Vector2(3, 15),
	1: Vector2(10, 12),
	2: Vector2(25, 5),
	3: Vector2(32, -5),
	4: Vector2(25, 5),
	5: Vector2(10, 12),
	6: Vector2(3, 15),
}

var right_hand_offsets_attacking_left = {
	0: Vector2(-3, 15),
	1: Vector2(-10, 12),
	2: Vector2(-25, 5),
	3: Vector2(-32, -5),
	4: Vector2(-25, 5),
	5: Vector2(-10, 12),
	6: Vector2(-3, 15),
}

var right_hand_offsets_facing_down = {
	0: Vector2(3, 16),
	1: Vector2(3, 16),
	2: Vector2(3, 16),
	3: Vector2(3, 16),
	4: Vector2(3, 16),
	5: Vector2(3, 15),
	6: Vector2(3, 14),
	7: Vector2(3, 15),
	8: Vector2(3, 16),
}

var right_hand_offsets_attacking_down = {
	0: Vector2(3, 16),
	1: Vector2(3, 9),
	2: Vector2(3, 2),
	3: Vector2(3, -5),
	4: Vector2(3, 2),
	5: Vector2(3, 9),
	6: Vector2(3, 16),
}

var attack_collision_coordinates = {
	"right":
	{
		"x": 57.25,
		"y": -0.5,
		"rotation": 0,
	},
	"left":
	{
		"x": -57.25,
		"y": -0.5,
		"rotation": 0,
	},
	"up":
	{
		"x": 0,
		"y": -91,
		"rotation": 90,
	},
	"down":
	{
		"x": 0,
		"y": 90,
		"rotation": 90,
	}
}

var attack_area_display_coordinates = {
	"right":
	{
		"size":
		{
			"x": 51,
			"y": 129,
		},
		"position":
		{
			"x": 32,
			"y": -65,
		}
	},
	"left":
	{
		"size":
		{
			"x": 51,
			"y": 129,
		},
		"position":
		{
			"x": -83,
			"y": -65,
		}
	},
	"up":
	{
		"size":
		{
			"x": 129,
			"y": 51,
		},
		"position":
		{
			"x": -64,
			"y": -116.5,
		}
	},
	"down":
	{
		"size":
		{
			"x": 129,
			"y": 51,
		},
		"position":
		{
			"x": -64,
			"y": 64,
		}
	}
}


func _ready():
	player_cam.zoom = Vector2(0.5, 0.5)
	attack_area.monitoring = false
	attack_area.body_entered.connect(_on_attack_area_entered)
	attack_area_display.visible = false
	attack_area_display.z_index = -100
	idle_upper_animation_string = "idle_down"
	idle_lower_animation_string = "idle_down"
	animated_upper_sprite.play(idle_upper_animation_string)
	animated_lower_sprite.play(idle_lower_animation_string)
	animated_upper_sprite.animation_finished.connect(upper_sprite_animation_finished)

	prevent_player_movement(0.1)

	# Spawn player with weapon but will remove this from code eventually
	weapon = weapon_scene.instantiate()
	weapon.position = right_hand_offsets_facing_sideways[0]
	add_child(weapon)


func get_input():
	var distance_from_walking_position = abs(walking_to_position - self.global_position)
	var is_character_blocked_from_moving = (
		abs(last_position - self.global_position) < Vector2(1.0, 1.0)
	)
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
		if not is_basic_attacking:
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
			idle_right_hand_position = right_hand_offsets_facing_down[0]
		else:
			direction = "up"

	var lower_current_frame = animated_lower_sprite.get_frame()
	var lower_current_progress = animated_lower_sprite.get_frame_progress()
	animated_lower_sprite.play("walk_" + direction)
	animated_lower_sprite.set_frame_and_progress(lower_current_frame, lower_current_progress)

	var upper_current_frame = animated_upper_sprite.get_frame()
	var upper_current_progress = animated_upper_sprite.get_frame_progress()
	if not is_basic_attacking:
		animated_upper_sprite.play("walk_" + direction)
		if need_to_sync_walking_animation:
			upper_current_frame = lower_current_frame
			upper_current_progress = lower_current_progress
			need_to_sync_walking_animation = false
	elif is_basic_attacking:
		animated_upper_sprite.play("basic_attack_" + direction)

	animated_upper_sprite.set_frame_and_progress(upper_current_frame, upper_current_progress)

	idle_upper_animation_string = "idle_" + direction
	idle_lower_animation_string = "idle_" + direction

	current_direction = direction

	if weapon:
		weapon.update_sprite(direction)


func _physics_process(_delta):
	if player_can_move:
		get_input()
		move_and_slide()
	set_attack_area_position()


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

	if attack_pressed and not is_basic_attacking:
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
	elif animated_upper_sprite.animation == "walk_down":
		right_hand_node.position = right_hand_offsets_facing_down[frame_number]
		direction = "down"
	elif animated_upper_sprite.animation == "walk_up":
		direction = "up"
	elif animated_upper_sprite.animation == "basic_attack_right":
		right_hand_node.position = right_hand_offsets_attacking_right[frame_number]
		direction = "right"
	elif animated_upper_sprite.animation == "basic_attack_left":
		right_hand_node.position = right_hand_offsets_attacking_left[frame_number]
		direction = "left"
	elif animated_upper_sprite.animation == "basic_attack_down":
		right_hand_node.position = right_hand_offsets_attacking_down[frame_number]
		direction = "down"
	elif animated_upper_sprite.animation == "basic_attack_up":
		direction = "up"

	if weapon:
		weapon.position = right_hand_node.position

		if direction in ["right", "down"]:
			weapon.z_index = 10
		elif direction in ["left", "up"]:
			weapon.z_index = -10


func attack():
	is_basic_attacking = true
	animated_upper_sprite.play("basic_attack_" + current_direction)

	if weapon and weapon.type != "meele":
		weapon.attack()
	else:
		attack_area.monitoring = true
		attack_area_display.visible = true
		await animated_upper_sprite.animation_finished
		attack_area_display.visible = false
		attack_area.monitoring = false


func _on_attack_area_entered(body):
	var enemy = body
	if enemy.is_in_group("enemy") and enemy.has_method("take_damage"):
		var damage = base_damage
		if weapon:
			damage = weapon.damage
		enemy.take_damage(damage)


func upper_sprite_animation_finished():
	if animated_upper_sprite.animation.begins_with("basic_attack"):
		is_basic_attacking = false
		need_to_sync_walking_animation = true


func prevent_player_movement(time):
	player_can_move = false
	await get_tree().create_timer(time).timeout
	player_can_move = true


func set_attack_area_position():
	var attack_collision_dimensions = attack_collision_coordinates[current_direction]
	var attack_area_dimensions = attack_area_display_coordinates[current_direction]

	attack_collision.position = Vector2(
		attack_collision_dimensions["x"], attack_collision_dimensions["y"]
	)
	attack_collision.rotation = attack_collision_dimensions["rotation"]

	attack_area_display.size = Vector2(
		attack_area_dimensions["size"]["x"], attack_area_dimensions["size"]["y"]
	)
	attack_area_display.position = Vector2(
		attack_area_dimensions["position"]["x"], attack_area_dimensions["position"]["y"]
	)
