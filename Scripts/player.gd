extends CharacterBody2D

@onready var player_cam = $PlayerCamera
@onready var attack_area = $AttackArea
@export var speed = 400

var max_zoom = 1.0
var min_zoom = 0.3
var camera_zoom_amount = 0.1

var weapon = null
var base_damage = 5.0

func _ready():
	player_cam.zoom = Vector2(0.5, 0.5)
	attack_area.monitoring = false
	attack_area.body_entered.connect(_on_attack_area_entered)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

	# TODO need to replace this logic with changing the sprite image of the
	# character.
	if input_direction != Vector2.ZERO:
		var target_angle = input_direction.angle()
		rotation = lerp_angle(rotation, target_angle, 0.15)

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
