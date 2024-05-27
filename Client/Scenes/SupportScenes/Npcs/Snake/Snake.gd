extends Node2D

var distanceTraveled
var health = 20
var speed = 50
var playersWhoDamaged = []
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("area_entered", self, "onHit")

func onHit(body):
	print("Collision")
	if body.get_parent().has_method("playerProjectile"):
		body.get_parent().interaction(true)
		health -= body.get_parent().damage
		if health <= 0:
			die()
func die():
	queue_free()
	print("I died")
func dropLoot():
	pass
	# Instantiate loot items at the enemy's position
	# Example: 
	# var loot_instance = loot_scene.instance()
	# loot_instance.position = position
	# get_parent().add_child(loot_instance)
