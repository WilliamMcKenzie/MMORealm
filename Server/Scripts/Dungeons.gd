extends Node

var valid_names = ["island","orc_vigil","orc_vigil_sanctum"]

func GetTileTranslation(instance_name):
	if instance_name == "orc_vigil":
		return {
			5 : "vigil_guardian",
			6 : "orc_monolith",
			7 : ["rock3","rock4"],
		}
	if instance_name == "orc_vigil_sanctum":
		return {
			5 : "atlas",
			7 : ["rock3","rock4"],
		}
	
	return {}
	
func GenerateDungeon(instance_name):
	if instance_name == "orc_vigil":
		return GenerateOrcVigil()
	if instance_name == "orc_vigil_sanctum":
		return GenerateOrcVigil()

func GenerateOrcVigil():
	var layout = {
		Vector2.ZERO : { "room_type" : "Spawn" }
	}
	return layout
func GenerateOrcVigilSanctum():
	var layout = {
		Vector2.ZERO : { "room_type" : "Spawn" }
	}
	return layout

func GenerateOvergrownTemple():
	randomize()
	var layout = {
		Vector2.ZERO : { "room_type" : "Spawn" }
	}
	var coordinates = Vector2.ZERO
	
	var rooms_until_boss = 5
	var twist_chance = 0.5
	
	var basic_rooms = [
		"Mage",
		"Melee",
		"Mixed",
	]
	
	var direction_clock = {
		Vector2(1,0) : Vector2(0,1),
		Vector2(0,1) : Vector2(-1,0),
		Vector2(-1,0) : Vector2(0,-1),
		Vector2(0,-1) : Vector2(1,0),
	} 
	var initial_direction = [Vector2(1,0),Vector2(-1,0),Vector2(0,1),Vector2(0,-1)][randi() % 4]
	var direction = initial_direction
	
	for rotation in range(4):
		var path = direction
		coordinates += direction
		
		#First, lets place the main path which contains the boss room.
		if rotation == 0:
			for i in range(rooms_until_boss):
				if(rand_range(0,1) < twist_chance):
					direction = TwistDirection(direction)
				
				#Make sure we arnt going to overwrite another room
				if layout.has(coordinates+direction):
					var count = 0
					while layout.has(coordinates+direction):
						count += 1
						if count > 5:
							break
						direction = TwistDirection(direction)
				
				var room = {
					"direction" : direction,
					"room_type" : basic_rooms[round(rand_range(0,basic_rooms.size()-1))],
					"root_path" : path
				}
				layout[coordinates] = room
				coordinates += direction
			
			var boss_room = {
					"room_type" : "Boss",
					"root_path" : path
			}
			layout[coordinates] = boss_room
		#Then, put the sub paths which are dead ends.
		else:
			for i in range(rooms_until_boss):
				if(rand_range(0,1) < twist_chance):
					direction = TwistDirection(direction)
				
				var room = {
					"room_type" : basic_rooms[round(rand_range(0,basic_rooms.size()-1))],
					"root_path" : path
				}
				
				#Make sure we arnt going to overwrite another room
				if layout.has(coordinates+direction):
					var count = 0
					while layout.has(coordinates+direction):
						count += 1
						if count > 5:
							break
						direction = TwistDirection(direction)
				
				#Make sure we arnt overwriting again, if so then we make sure not to connect with a hallway
				if not layout.has(coordinates+direction) and i < rooms_until_boss-1:
					room.direction = direction
				
				if not layout.has(coordinates):
					layout[coordinates] = room
					coordinates += direction
				else:
					break
		
		coordinates = Vector2.ZERO
		direction = direction_clock[path]
	return layout
		
	
func TwistDirection(direction):
	var direction_map = {
		Vector2(1,0) : [Vector2(0,1), Vector2(0,-1)],
		Vector2(-1,0) : [Vector2(0,1), Vector2(0,-1)],
		Vector2(0,1) : [Vector2(1,0), Vector2(-1,0)],
		Vector2(0,-1) : [Vector2(1,0), Vector2(-1,0)],
	}
	return direction_map[direction][randi() % 2]
