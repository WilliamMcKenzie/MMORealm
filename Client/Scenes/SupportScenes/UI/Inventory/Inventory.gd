extends GridContainer

func UseItem(index):
	Server.EquipItem(index)

func SetInventory(inventory):
	var inventory_slots = $ResizeContainer.get_children()
	var i = 0
	
	for slot in inventory_slots:
		slot.SetItem(inventory[i], 1)
		i += 1

func SetGear(gear):
	var gear_slots = $GearContainer.get_children()
	
	if gear.has("weapon"):
		gear_slots[0].SetItem(gear["weapon"], 1)
	else:
		gear_slots[0].SetItem(null, 1)
	if gear.has("helmet"):
		gear_slots[1].SetItem(gear["helmet"], 1)
	else:
		gear_slots[1].SetItem(null, 1)
	if gear.has("armor"):
		gear_slots[2].SetItem(gear["armor"], 1)
	else:
		gear_slots[2].SetItem(null, 1)
