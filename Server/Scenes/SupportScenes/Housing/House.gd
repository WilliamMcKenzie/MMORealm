extends "res://Scenes/Main/Nexus.gd"

var player_id
var open_mode = "closed"
var whitelist = []
var tiles = []


func SetHouseData(account_data):
	var house_data = account_data.home
	whitelist = []
	object_list = {}
	
	whitelist.append(account_data.username)
	whitelist += house_data.whitelist
	open_mode = house_data.open_mode
	tiles = house_data.tiles
	
	var index = -1
	for object in house_data.objects:
		index += 1
		if object.type == "storage":
			CreateStorage(object, index)

func CreateStorage(object, index):
	var storage_id = "loot "+get_node("/root/Server").generate_unique_id()+" "+str(index)
	object_list[storage_id] = {
		"name": "Storage",
		"index" : index,
		
		"soulbound": true,
		"tier": 0,
		"loot": object.loot,
		"player_id": player_id,
		"type": "LootBags",
		"end_time": OS.get_system_time_msecs()+OS.get_system_time_msecs(),
		"position": object.position,
		"instance_tree": instance_tree
	}

func RequestEntry(username):
	var on_whitelist = whitelist.has(username)
	var all = open_mode == "open"
	
	if on_whitelist or all:
		return true
	return false

func SaveData():
	var server = get_node("/root/Server")
	var instance_tree = server.player_state_collection[player_id]["I"]
	var player_container = server.get_node("Instances/"+server.StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
	
	var house_data = player_container.account_data.home
	house_data.whitelist = whitelist
	house_data.tiles = tiles
	
	for object_id in object_list.keys():
		var object = object_list[object_id]
		
		#Update the accountdata to save it to the database
		if object.name == "Storage":
			player_container.account_data.home.objects[object.index] = {
				"type" : "storage",
				"position" : object.position,
				"loot" : object.loot,
			}
