extends "res://Scenes/Main/Nexus.gd"

var player_id
var open_mode = "closed"
var whitelist = []
var tiles = []

#For furnitures like statues to buff players
var sync_clock_counter = 0
func _process(delta):
	sync_clock_counter += 1
	if sync_clock_counter > 20:
		sync_clock_counter = 0
		for object_id in object_list.keys():
			var object = object_list[object_id]
			if object.name == "Statue":
				if object.building_id == "knight_statue":
					print("Knight spotted")

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
			CreateStatue(object, index)

func CreateStorage(object, index):
	var storage_id = "loot "+get_node("/root/Server").generate_unique_id()+" "+str(index)
	object_list[storage_id] = {
		"name": object.type,
		"index" : index,
		
		"soulbound": true,
		"tier": 0,
		"loot": object.loot,
		"player_id": str(player_id),
		"type": "LootBags",
		"end_time": OS.get_system_time_msecs()+OS.get_system_time_msecs(),
		"position": object.position,
		"instance_tree": instance_tree
	}

func CreateStatue(object, index):
	var statue_id = "statue "+get_node("/root/Server").generate_unique_id()+" "+str(index)
	object_list[statue_id] = {
		"name": object.type,
		"index" : index,
		
		"end_time": OS.get_system_time_msecs()+OS.get_system_time_msecs(),
		"type" : "Buildings",
		"position": object.position,
		"instance_tree": instance_tree
	}

func PlaceBuilding(_type, _position):
	var building_data = ServerData.GetBuilding(_type)
	var house_data = get_node("YSort/Players/"+str(player_id)).account_data.home
	if not building_data:
		return
	elif building_data.type == "object" and house_data.inventory.objects[_type] > 0:
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
		if building_data.catagory == "statue":
			var new_statue = {
				"type" : _type,
				"position" : _position,
			}
			house_data.objects.append(new_statue)
			house_data.inventory.objects[_type] -= 1
			CreateStatue(new_statue, house_data.objects.size()-1)
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

func BuildBuilding(type):
	var server = get_node("/root/Server")
	var instance_tree = server.player_state_collection[player_id]["I"]
	var player_container = server.get_node("Instances/"+server.StringifyInstanceTree(instance_tree)+"/YSort/Players/"+str(player_id))
	var inventory = player_container.character.inventory.duplicate()
	var house_data = player_container.account_data.home
	
	var building = ServerData.GetBuilding(type)
	
	#Check if craftable
	if not building.craftable:
		return
	
	#Check if building is maxed out
	if building.has("max"):
		var total = house_data.inventory[building.type+"s"][type]
		for _building in house_data[building.type+"s"]:
			if not "tileset" in building.path[0] and _building.type == "object" and _building.type == type:
				total += 1
			elif "tileset" in building.path[0]:
				var row = _building
				for tile in row:
					if tile == building.tile:
						total += 1
		
		if total > building.max:
			return
	
	#Check if has nessecary materials
	var material_pile = {}
	var materials = building.materials.duplicate()
	var index = -1
	
	for item in inventory:
		if item and material_pile.has(int(item.item)):
			material_pile[int(item.item)] += 1
		elif item:
			material_pile[int(item.item)] = 1
	for _material in materials:
		index += 1
		if material_pile.has(_material):
			material_pile[_material] -= 1
			if material_pile[_material] == 0:
				material_pile.erase(_material)
		else:
			return
	
	#Finally execute in building the building
	index = -1
	for item in inventory:
		index += 1
		if item and materials.has(int(item.item)):
			materials.erase(int(item.item))
			player_container.character.inventory[index] = null
	
	house_data.inventory[building.type+"s"][type] += 1
	server.SendCharacterData(player_container.name, player_container.character)
	server.rpc_id(player_id, "UpdateHouseData", house_data)

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
		if ServerData.buildings.has(object.name):
			player_container.account_data.home.objects[object.index] = {
				"type" : object.name,
				"position" : object.position,
			}
			if ServerData.GetBuilding(object.name).catagory == "storage":
				player_container.account_data.home.objects[object.index]["loot"] = object.loot
