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
		if ServerData.GetBuilding(object.type).catagory == "storage":
			CreateStorage(object, index)
		if ServerData.GetBuilding(object.type).catagory == "statue":
			pass
			#CreateStatue(object, index)

func PlaceBuilding(_type, _position):
	var building_data = ServerData.GetBuilding(_type)
	var house_data = get_node("YSort/Players/"+str(player_id)).account_data.home
	if not building_data:
		return
	elif building_data.type == "building" and house_data.inventory.objects[_type] > 0:
		if building_data.catagory == "storage":
			var new_storage = {
				"type" : _type,
				"position" : _position,
				"loot" : [
					null,
					null,
					null,
					null,
					null,
					null,
					null,
					null,
				],
			}
			house_data.objects.append(new_storage)
			house_data.inventory.objects[_type] -= 1
			CreateStorage(new_storage, house_data.objects.size()-1)
	elif building_data.type == "tile" and house_data.tiles.size() > _position.x and house_data.tiles[_position.x].size() > _position.y:
		var previous_tile_type
		var previous_tile = house_data.tiles[_position.x][_position.y]
		var new_tile = building_data.tile
		
		for building in ServerData.buildings.keys():
			var tile_data = ServerData.buildings[building]
			if tile_data.has("tile") and tile_data.tile == previous_tile:
				previous_tile_type = building
				break;
		
		if house_data.inventory.tiles[_type] > 0:
			house_data.inventory.tiles[previous_tile_type] += 1
			house_data.inventory.tiles[_type] -= 1
			house_data.tiles[_position.x][_position.y] = new_tile
	var server = get_node("/root/Server")
	server.rpc_id(player_id, "UpdateHouseData", house_data)
	for _player_id in server.player_instance_tracker[["nexus", name]]:
		server.rpc_id(_player_id, "UpdateHouseTiles", house_data.tiles)

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
