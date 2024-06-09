extends Node

var valid_names = ["island","test_dungeon"]

func GenerateDungeon(instance_name):
	if instance_name == "island":
		return GenerateIslandMap()
	if instance_name == "test_dungeon":
		return GenerateTestDungeon()

func GenerateIslandMap():
	pass
	

func GenerateTestDungeon():
	randomize()
	var layout = []
	var rooms_until_boss = 3
	
	var boss_has_been_placed = false
	var boss_root = -1
	
	for i in range(4):
		layout.append([])
		for k in range(rooms_until_boss):
			if k < rooms_until_boss:
				if not boss_root == k:
					layout[i].append("Room")
				if round(rand_range(0,3)) == 3 and boss_has_been_placed == false:
					layout[i].append("Boss")
					boss_has_been_placed = true
					boss_root = k
	if not boss_has_been_placed:
		layout[round(rand_range(0,3))].append("BossRoom")
	return layout
		
	
