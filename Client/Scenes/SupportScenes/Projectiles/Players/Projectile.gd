extends Node2D

var projectile
var damage
var speed = 0
var tile_range = 0
var piercing

var initial_position = Vector2.ZERO
var velocity = Vector2.ZERO

func _ready():
	initial_position = position
	SetData(ClientData.GetProjectile(projectile))
func SetData(data):
	speed = data.speed
	piercing = data.piercing
	velocity *= speed
	
func _process(delta):
	position += velocity * delta
	if (position - initial_position).length()/8 > tile_range:
		queue_free()
	
func set_direction(direction: Vector2):
	velocity = direction.normalized()

func interaction(body):
	if (piercing == false) and (body.name == "Axis") :
		queue_free()
