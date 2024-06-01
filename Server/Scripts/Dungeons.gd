extends Node

func GenerateDungeon(instance_name):
	if instance_name == "test_dungeon":
		return GenerateTestDungeon()

func GenerateTestDungeon():
	randomize()
	var layout = []
	var rooms_until_boss = 3
	var boss_has_been_placed = false
	
	for i in range(4):
		layout.append([])
		for k in range(rooms_until_boss):
			if k < rooms_until_boss:
				if boss_has_been_placed == false:
					layout[i].append("R")
				if round(rand_range(0,3)) == 3 and boss_has_been_placed == false:
					layout[i].append("B")
					boss_has_been_placed = true
					print(boss_has_been_placed)
	if not boss_has_been_placed:
		layout[round(rand_range(0,3))].append("B")
	print(layout)
	return layout
		
	
