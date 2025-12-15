extends CharacterBody2D
class_name BasePlayer

@onready var player_cam = $PlayerCamera
@onready var attack_area = $AttackArea
@export var speed = 400
@onready var animated_player_sprite = $AnimatedPlayerSprite
@onready var player_collision_shape = $PlayerCollisionShape


var character_type = ""
var max_zoom = 1.0
var min_zoom = 0.5
var camera_zoom_amount = 0.1

var weapon = null
var base_damage = 5.0

var idle_animation_string = ""
var walk_up_animation_string = ""
var walk_down_animation_string = ""
var walk_left_animation_string = ""
var walk_right_animation_string = ""

func _ready():
	player_cam.zoom = Vector2(0.5, 0.5)
	attack_area.monitoring = false
	attack_area.body_entered.connect(_on_attack_area_entered)
	idle_animation_string = "idle_down"
	walk_up_animation_string = "walk_up"
	walk_down_animation_string = "walk_down"
	walk_right_animation_string = "walk_right"
	walk_left_animation_string = "walk_left"
	animated_player_sprite.play(idle_animation_string)


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

	update_player_sprite_direction(input_direction)

func update_player_sprite_direction(input_direction: Vector2):
	if input_direction == Vector2.ZERO:
		animated_player_sprite.play(idle_animation_string)
		return

	if abs(input_direction.x) > abs(input_direction.y):
		if input_direction.x > 0:
			animated_player_sprite.play(walk_right_animation_string)
			idle_animation_string = "idle_right"
		else:
			animated_player_sprite.play(walk_left_animation_string)
			idle_animation_string = "idle_left"
	else:
		if input_direction.y > 0:
			animated_player_sprite.play(walk_down_animation_string)
			idle_animation_string = "idle_down"
		else:
			animated_player_sprite.play(walk_up_animation_string)
			idle_animation_string = "idle_up"

func _physics_process(_delta):
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
