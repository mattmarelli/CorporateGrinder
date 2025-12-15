extends Enemy

var speed = 150
var player = null
@onready var meele_enemy_animated_sprite = $MeeleEnemyAnimatedSprite
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
			meele_enemy_animated_sprite.play(idle_animation_string)
			return

		if abs(move_direction.x) > abs(move_direction.y):
			if move_direction.x > 0:
				meele_enemy_animated_sprite.play("walk_right")
				idle_animation_string = "idle_right"
			else:
				meele_enemy_animated_sprite.play("walk_left")
				idle_animation_string = "idle_left"
		else:
			if move_direction.y > 0:
				meele_enemy_animated_sprite.play("walk_down")
				idle_animation_string = "idle_down"
			else:
				meele_enemy_animated_sprite.play("walk_up")
				idle_animation_string = "idle_up"

		move_and_slide()
