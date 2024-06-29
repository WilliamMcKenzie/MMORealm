extends Node2D

var projectile
var damage
var speed = 0
var tile_range = 0
var piercing
var formula
var time = 0
var direction
var path
onready var expression = Expression.new()

var initial_position = Vector2.ZERO
var velocity = Vector2.ZERO

func _ready():
	$Area2D.connect("body_entered", self, "WallCollision")
	initial_position = position
	SetData(ClientData.GetProjectile(projectile))
	path = position
func SetData(data):
	speed = data.speed
	piercing = data.piercing
	velocity *= speed
	formula = data.formula
func WallCollision(area):
	if area.name == "TileMap":
		queue_free()
func _process(delta):
	time += delta
	expression.parse(formula,["x"])
	var initial_offset = velocity * delta
	path = path + initial_offset
	var pattern_offset = Vector2(-velocity.y, velocity.x) * expression.execute([time * 50]) * 0.05
	position = path + pattern_offset
	if (position - initial_position).length()/8 > tile_range:
		queue_free()
func set_direction(direction: Vector2):
	velocity = direction.normalized()
	direction = direction
func interaction(body):
	if (piercing == false) and (body.has_method("MoveEnemy")) :
		queue_free()
