extends CharacterBody2D
class_name Enemy

@onready var health_bar = $HealthBar

var starting_health
var current_health

func _ready():
	update_health_bar()

func init(_health=100):
	starting_health = _health
	current_health = _health

func take_damage(damage):
	current_health -= damage
	update_health_bar()
	if current_health <= 0:
		despawn()

func drop_loot():
	pass

func despawn():
	drop_loot()
	self.get_parent().remove_child(self)
	self.queue_free()

func update_health_bar():
	print("UPDATE HEALTH BAR CALLED!!!!")
	health_bar.value = (self.current_health / self.starting_health) * 100
