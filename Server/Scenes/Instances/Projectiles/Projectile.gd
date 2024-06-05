extends Node2D

var projectile_name
var player_id

var damage = 0
var speed = 50
var tile_range = 0
var piercing = false

var initial_position = Vector2.ZERO
var velocity = Vector2.ZERO

func _ready():
	$Area2D.connect("area_entered", self, "Interaction")
	SelfDestruct()

func SetData(data):
	damage = data.damage
	speed = data.speed
	piercing = data.piercing
	velocity *= speed
	
func _process(delta):
	position += velocity * delta
	
func SelfDestruct():
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
	
func SetDirection(direction: Vector2):
	velocity = direction.normalized()

func Interaction(body):
	if (piercing == false) and (body.get_parent().get_parent().name == "Enemies") :
		body.get_parent().DealDamage(damage)
		queue_free()
