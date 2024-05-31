extends Node

var player_data

func _ready():
	updateInfo()

func updateInfo():
	var player_data_file = File.new()
	player_data_file.open("res://Data/PlayerData.json", File.READ)
	var player_data_json = JSON.parse(player_data_file.get_as_text())
	player_data_file.close()
	player_data = player_data_json.result

func savePlayerIDs():
	var save_file = File.new()
	save_file.open("res://Data/PlayerData.json", File.WRITE)
	save_file.store_line(to_json(player_data))
	save_file.close()
	updateInfo()
