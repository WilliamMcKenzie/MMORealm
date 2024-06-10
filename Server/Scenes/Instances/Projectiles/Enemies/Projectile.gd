extends Node2D

var projectile_name
var enemy_id

var damage = 0
var speed = 50
var tile_range = 0
var piercing = false

var initial_position = Vector2.ZERO
var velocity = Vector2.ZERO

func _ready():
	$EnemyProjectileHitbox.connect("area_entered", self, "Interaction")
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
	var player = body.get_parent().name == "PlayerCharacter"
	var enemy = (piercing == false) and (body.get_parent().name == "Enemies")
	var enemy_ai = body.get_parent().name == "Ai"
	var wall = body.get_parent().name != "ChunkSensors" and body.name != "PlayerProjectileHitbox" and body.name != "EnemyProjectileHitbox" and body.get_parent().get_parent().name != "Enemies" and body.get_parent().get_parent().name != "Players"
	
	if enemy_ai or enemy:
		pass
	elif wall:
		queue_free()
	elif player and not piercing:
		queue_free()
