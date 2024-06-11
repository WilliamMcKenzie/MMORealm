extends Node2D

var damage
var speed = 50
var tile_range = 4
var piercing

var initial_position = Vector2.ZERO
var velocity = Vector2.ZERO

func _ready():
	initial_position = position
	var projectile_data_file = File.new()
	projectile_data_file.open("res://Data/Projectiles.json", File.READ)
	var projectile_data_json = JSON.parse(projectile_data_file.get_as_text())
	projectile_data_file.close()
	var projectile_data = projectile_data_json.result
	SetData(projectile_data.arrow)
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
