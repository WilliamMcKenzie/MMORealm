extends Node2D

var damage
var speed = 50
var tile_range
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
	selfDestruct()
	
func _process(delta):
	position += velocity * delta
	
func selfDestruct():
	yield(get_tree().create_timer(0.5), "timeout")
	print("uque free")	
	queue_free()
	
func set_direction(direction: Vector2):
	velocity = direction.normalized()

func interaction(body):
	print(body)
	if (piercing == false) and (body.get_parent().name == "Enemies") :
		queue_free()
