extends TextureButton

var parent
var index

var dragging = false
var item = null
var quantity = 1

var last_click = 10000
func _physics_process(delta):
	last_click += delta

func _ready():
	if str(OS.get_model_name()) == 'GenericDevice':
		connect("pressed", self, "InspectItem")
	else:
		$TouchScreenButton.connect("pressed", self, "InspectItem")
	connect("mouse_exited", self, "DeInspectItem")
	connect("focus_exited", self, "DeInspectItem")

func _input(event):
	# Check if the event is a mouse button release
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed() == false:
		if dragging:
			StopDragging()
	
	if event is InputEventScreenTouch and not event.is_pressed():
		if dragging:
			StopDragging()

func StopDragging():
	dragging = false
	
	var timer = Timer.new()
	timer.wait_time = 0.2
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	GameUI.SetCharacterData(GameUI.last_character)
	GameUI.get_node("Inventory").SetLoot(GameUI.get_node("Inventory").loot_container_id, GameUI.get_node("Inventory").loot)

func get_drag_data(position):
	if item == null:
		return
	dragging = true
	
	var data = {}
	data["parent"] = parent
	data["index"] = index
	
	var drag_texture = TextureRect.new()
	
	drag_texture.expand = true
	drag_texture.texture = AtlasTexture.new()
	drag_texture.texture.atlas = get_node("ItemIcon").texture.atlas.duplicate(true)
	drag_texture.texture.region = get_node("ItemIcon").texture.region
	drag_texture.material = get_node("ItemIcon").material.duplicate()
	drag_texture.rect_size = Vector2(40,40)
	
	var preview = Control.new()
	preview.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size	
	set_drag_preview(preview)
	
	get_node("ItemIcon").visible = false
	
	return data
	
func can_drop_data(position, data):
	return true
	
func drop_data(position, data):
	#If we drop an item in this slot
	var current_data = {
		"parent" : parent,
		"index" : index
	}
	GameUI.get_node("Inventory").ChangeItem(current_data, data)

func InspectItem():
	if last_click < 1 and parent == "inventory" and item:
		last_click = 1
		AudioManager.Play("action", 1)
		GameUI.get_node("Inventory").UseItem(index)
		GameUI.get_node("Inventory").EquipItem(index)
	elif last_click < 1 and parent != "gear" and item:
		last_click = 1
		for _index in range(GameUI.last_character.inventory.size()):
			if GameUI.last_character.inventory[_index] == null:
				var current_data = {
					"parent" : "inventory",
					"index" : _index
				}
				var data = {
					"parent" : parent,
					"index" : index
				}
				GameUI.get_node("Inventory").ChangeItem(current_data, data)
				break
	else:
		last_click = 0
	GameUI.get_node("Inventory").InspectItem(item)
func DeInspectItem():
	if item:
		GameUI.get_node("Inventory").DeInspectItem(item)

func SetItem(_item, _quantity):
	item = _item
	quantity = _quantity
	
	if item and has_node("TutorialArrow") and ((GameUI.get_node("NpcDialogue").subject == "Stats" and item.item == 0) or (GameUI.get_node("NpcDialogue").subject == "Backpack" and item.item == 400)):
		$TutorialArrow.visible = true
		$TutorialArrow2.visible = true
	elif has_node("TutorialArrow"):
		$TutorialArrow.visible = false
		$TutorialArrow2.visible = false
	if item == null:
		$ItemIcon.visible = false
		$ItemBackground.visible = true
	else:
		$ItemIcon.visible = true
		$ItemBackground.visible = false
		SetSpriteData($ItemIcon, ClientData.GetItem(item.item).path)
		
		#Outline
		var starting_colour = Color(0,0,0)
		var ending_colour = Color(0,0,0)
		starting_colour.a = 2.0
		ending_colour.a = 0.0
		
		if ClientData.GetItem(item.item).has("outline"):
			ending_colour = ClientData.GetItem(item.item).outline
			starting_colour.a = 3.0
			ending_colour.a = 0.0
		
		$ItemIcon.material = $ItemIcon.material.duplicate()
		$ItemIcon.material.set_shader_param("starting_colour", starting_colour)
		$ItemIcon.material.set_shader_param("ending_colour", ending_colour)

func GetItem():
	return {
		"Item" : item,
		"Quantity" : quantity
	}

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0])
	sprite.texture = AtlasTexture.new()
	
	sprite.texture.atlas = spriteTexture
	sprite.texture.region = Rect2(path[3]*10, Vector2(10,10))
	
