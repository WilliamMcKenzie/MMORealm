extends TextureButton

func can_drop_data(position, data):
	return true
	
func drop_data(position, data):
	GameUI.get_node("Inventory").DropItem(data)
