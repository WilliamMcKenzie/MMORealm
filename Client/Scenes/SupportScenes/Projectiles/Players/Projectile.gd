extends Node2D

onready var expression = Expression.new()
var initial_position = Vector2.ZERO
var velocity = Vector2.ZERO
var original = true

var projectile
var tile_range = 0
var direction
var piercing
var formula
var damage
var speed = 0
var size = 0
var time = 0
var path

func _ready():
	$Area2D.connect("body_entered", self, "WallCollision")
	initial_position = position
	path = position
	velocity *= speed
	
	$Area2D/Hitbox.shape.radius = size 
	$Sprite.texture = $Sprite.texture.duplicate()
	$Sprite.texture.region = ClientData.GetProjectile(projectile).rect
	$Sprite.rotation_degrees = ClientData.GetProjectile(projectile).rotation

func WallCollision(area):
	if area.name == "TileMap" or "object_id" in area.get_parent():
		queue_free()

func _process(delta):
	if ClientData.GetProjectile(projectile).spin:
		$Sprite.rotation_degrees += delta
	
	time += delta
	expression.parse(formula,["x"])
	var initial_offset = velocity * delta
	path = path + initial_offset
	var pattern_offset = Vector2(-velocity.y, velocity.x) * expression.execute([time * 50]) * 0.05
	position = path + pattern_offset
	if (position - initial_position).length()/8 > tile_range:
		queue_free()

func set_direction(direction: Vector2):
	self.velocity = direction.normalized()
	self.direction = direction

func interaction(body):
	if (piercing == false) and (body.has_method("MoveEnemy")) :
		queue_free()
