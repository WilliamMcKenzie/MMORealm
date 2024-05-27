extends Node

var projectile_data

func _ready():
	var projectile_data_file = File.new()
	projectile_data_file.open("res://Data/Projectiles.json", File.READ)
	var projectile_data_json = JSON.parse(projectile_data_file.get_as_text())
	projectile_data_file.close()
	projectile_data = projectile_data_json.result
