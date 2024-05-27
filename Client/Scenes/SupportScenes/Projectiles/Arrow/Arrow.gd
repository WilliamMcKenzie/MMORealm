extends Node2D

var damage = 0
var speed = 0
var lifetime = 0
var piercing = false

var initial_position = Vector2.ZERO
var velocity = Vector2.ZERO

func _ready():
	initial_position = position
	Server.fetchProjectileData("arrow", get_instance_id())
func SetData(data):
	damage = round(rand_range(data.damage[0], data.damage[1]))
	speed = data.speed
	lifetime = data.lifetime
	piercing = data.piercing
	velocity *= speed
	selfDestruct()
	
func _process(delta):
	position += velocity * delta
	
func selfDestruct():
	yield(get_tree().create_timer(lifetime), "timeout")
	queue_free()
	
func set_direction(direction: Vector2):
	velocity = direction.normalized()
	
func playerProjectile():
	pass
	
func interaction(isEnemy):
	if piercing == false and isEnemy == true:
		queue_free()
