extends Enemy

var speed = 150
var player = null
@onready var animated_sprite_upper = $AnimatedSpriteUpper
@onready var animated_sprite_lower = $AnimatedSpriteLower
var idle_animation_string = "idle_down"


func init(_health = 100):
	super.init(_health)


func _ready():
	super._ready()
	player = get_tree().get_root().find_child("player", true, false)


func _physics_process(_delta):
	if player:
		var move_direction = (player.global_position - self.global_position).normalized()
		velocity = move_direction * speed

		if move_direction == Vector2.ZERO:
			animated_sprite_lower.play(idle_animation_string)
			animated_sprite_upper.play(idle_animation_string)
			return

		var direction = null

		if abs(move_direction.x) > abs(move_direction.y):
			if move_direction.x > 0:
				direction = "right"
			else:
				direction = "left"
		else:
			if move_direction.y > 0:
				direction = "down"
			else:
				direction = "up"
		
		idle_animation_string = "idle_" + direction
		animated_sprite_upper.play("walk_" + direction)
		animated_sprite_lower.play("walk_" + direction)
		move_and_slide()
