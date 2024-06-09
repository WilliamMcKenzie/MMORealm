extends Area2D

var chunk_size
var chunk

func _ready():
	var collision_shape = $Collider
	collision_shape.shape.extents = Vector2((chunk_size/2)*8, (chunk_size/2)*8)
	connect("area_entered", self, "AddChunkData")
	connect("area_exited", self, "RemoveChunkData")

func AddChunkData(body):
	var enemy = body.name == "EnemyHitbox"
	var player = body.name == "PlayerHitbox"
	if enemy:
		get_parent().get_parent().AddChunkData(chunk, body.get_parent().name, false)
	elif player:
		get_parent().get_parent().AddChunkData(chunk, body.get_parent().name, true)
func RemoveChunkData(body):
	var enemy = body.name == "EnemyHitbox"
	var player = body.name == "PlayerHitbox"
	if enemy:
		get_parent().get_parent().RemoveChunkData(chunk, body.get_parent().name, false)
	elif player:
		get_parent().get_parent().AddChunkData(chunk, body.get_parent().name, true)
