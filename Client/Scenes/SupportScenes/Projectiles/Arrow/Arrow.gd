extends Node2D

var damage = 60
var speed = 60
var initial_position = Vector2.ZERO
var distance_traveled = 0
var max_distance = (4)*8

var piercing  = false
var velocity = Vector2.ZERO

func _process(delta):
	position += velocity * delta
	distance_traveled = (position - initial_position).length()
	if distance_traveled >= max_distance:
		queue_free()
func set_direction(direction: Vector2):
	velocity = direction.normalized() * speed
func playerProjectile():
	pass
func _ready():
	initial_position = position
func interaction(isEnemy):
	if piercing == false and isEnemy == true:
		queue_free()
