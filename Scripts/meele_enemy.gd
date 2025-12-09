extends Enemy

var speed = 150
var player = null

func init(_health=100):
	super.init(_health)

func _ready():
	super._ready()
	player = get_tree().get_root().find_child("player", true, false)

func _physics_process(_delta):
	if player:
		var move_direction = (player.global_position - self.global_position).normalized()
		velocity = move_direction * speed
		
		# TODO need to change this so that the correct sprite is shown not an
		# actuall rotation of the character body
		if move_direction != Vector2.ZERO:
			rotation = move_direction.angle()

		move_and_slide()
