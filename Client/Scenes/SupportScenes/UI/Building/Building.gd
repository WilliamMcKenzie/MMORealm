extends CanvasLayer

var active = false
var brush = ""
var inspecting_building = null

var previous_tile = Vector2(0,0)
func _physics_process(delta):
	var node =  Server.GetCurrentInstanceNode() if Server.GetCurrentInstance() != "nexus" else false
	var is_home = node and node.has_node("PlacementPreview")
	
	if is_home:
		var mouse_position = get_viewport().get_mouse_position()
		var x = round(mouse_position.x/8*0.2 + node.get_node("YSort/player").position.x/8)
		var y = round(mouse_position.y/8*0.2 + node.get_node("YSort/player").position.y/8)
		#node.get_node("PlacementPreview").set_cell(x-10, y-6, 1)

func _ready():
	$PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/ExitButton.connect("pressed", self, "ToggleBuilding")
	$PanelContainer/MarginContainer/VBoxContainer/OpenContainer/StateContainer.connect("pressed", self, "ToggleState")

func InspectBuilding(_type):
	if not _type or not ClientData.GetBuilding(_type):
		return
	
	var building = ClientData.GetBuilding(_type)
	
	if inspecting_building != _type:
		var animator = $BuildingAnimations
		animator.play("InspectBuilding")
		inspecting_building = _type
	$InspectBuilding.visible = true
	
	var building_name = $InspectBuilding/MarginContainer/VBoxContainer/BuildingName
	var building_sprite = $InspectBuilding/MarginContainer/VBoxContainer/BuildingSpriteContainer/BuildingSprite
	var building_description = $InspectBuilding/MarginContainer/VBoxContainer/BuildingDescription
	
	var materials_tag = $InspectBuilding/MarginContainer/VBoxContainer/BuildingMaterials/Tag
	var building_materials = $InspectBuilding/MarginContainer/VBoxContainer/BuildingMaterials/MaterialsContainer
	var uncraftable_tag = $InspectBuilding/MarginContainer/VBoxContainer/BuildingMaterials/Uncraftable
	var craft_tag = $InspectBuilding/MarginContainer/VBoxContainer/BuildingMaterials/Craftable
	var max_tag = $InspectBuilding/MarginContainer/VBoxContainer/BuildingMaterials/Max
	
	building_name.text = building.name
	building_description.text = building.description + "\n"
	
	var spriteTexture = load("res://Assets/"+building.path[0])
	building_sprite.texture.atlas = spriteTexture
	building_sprite.texture.region = Rect2(building.path[3], Vector2(260/building.path[2],260/building.path[2]))
	
	if building.has("wall"):
		building_sprite.texture.region = Rect2(building.path[3], Vector2(10,20))
	
	if "tileset" in building.path[0]:
		building_sprite.material = null
	else:
		building_sprite.material = load("res://Resources/Renderer.tres")
	
	if not building.craftable:
		uncraftable_tag.visible = true
		craft_tag.visible = false
		building_materials.visible = false
		materials_tag.visible = false
	else:
		uncraftable_tag.visible = false
		craft_tag.visible = true
		building_materials.visible = true
		materials_tag.visible = true
	if building.has("max"):
		var total = 0
		if GameUI.account_data.home.inventory[building.type+"s"].has(_type):
			total = GameUI.account_data.home.inventory[building.type+"s"][_type]
		
		for _building in GameUI.account_data.home[building.type+"s"]:
			if building.type == "object" and _building.type == _type:
				total += 1
			elif building.type == "tile":
				var row = _building
				for tile in row:
					if tile == building.tile:
						total += 1
		
		max_tag.visible = true
		max_tag.text = "[" + str(total) + "/" + str(building.max) + "]"
	else:
		max_tag.visible = false

	if building.craftable:
		var materials = building.materials
		var index = -1
		
		building_materials.visible = true
		for child in building_materials.get_children():
			building_materials.remove_child(child)
		
		var inventory = GameUI.last_character.inventory
		var material_pile = {}
		for item in inventory:
			if item and material_pile.has(int(item.item)):
				material_pile[int(item.item)] += 1
			elif item:
				material_pile[int(item.item)] = 1
		for material in materials:
			index += 1
			var material_instance = load("res://Scenes/SupportScenes/UI/Building/Material/Material.tscn").instance()
			material_instance.SetMaterial(material)
			material_instance.name = str(material) + "#" + str(index)
			
			if material_pile.has(material):
				material_pile[material] -=1
				material_instance.HasMaterial()
				if material_pile[material] == 0:
					material_pile.erase(material)
			else:
				material_instance.MissingMaterial()
			
			building_materials.add_child(material_instance)
	else:
		building_materials.visible = false

func DeInspectBuilding(_type):
	if inspecting_building == _type:
		var animator = $BuildingAnimations
		animator.play("DeInspectBuilding")
		inspecting_building = null
		
		var timer = Timer.new()
		timer.wait_time = 0.2
		timer.one_shot = true
		add_child(timer)
		timer.start()
		yield(timer, "timeout")
		
		$InspectBuilding.visible = false

func ToggleBuilding():
	get_parent().Toggle("building")

func Open():
	if active:
		return
	
	var storage_tween = $StorageTween
	var info_tween = $InfoTween
	
	var storage_element = $StorageContainer
	var info_element = $PanelContainer
	
	storage_tween.interpolate_property(storage_element, "rect_position", storage_element.rect_position, Vector2(0, -60)+storage_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	storage_tween.start()
	info_tween.interpolate_property(info_element, "rect_position", info_element.rect_position, Vector2(-170, 0)+info_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	info_tween.start()
	
	var timer = Timer.new()
	timer.wait_time = 0.4
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	$BuildingBackground.visible = true
	active = true

func Close():
	if not active:
		return
	
	var storage_tween = $StorageTween
	var info_tween = $InfoTween
	
	var storage_element = $StorageContainer
	var info_element = $PanelContainer
	
	storage_tween.interpolate_property(storage_element, "rect_position", storage_element.rect_position, Vector2(0, 60)+storage_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	storage_tween.start()
	info_tween.interpolate_property(info_element, "rect_position", info_element.rect_position, Vector2(170, 0)+info_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	info_tween.start()
	
	$BuildingBackground.visible = false
	active = false

func SetHouseData(house_data):
	if inspecting_building:
		InspectBuilding(inspecting_building)
	var whitelist = house_data.whitelist
	var open_mode = house_data.open_mode
	var state_container = $PanelContainer/MarginContainer/VBoxContainer/OpenContainer/StateContainer/HBoxContainer
	var guest_list = $PanelContainer/MarginContainer/VBoxContainer/GuestlistContainer/MarginContainer/ScrollContainer/Guestlist
	
	if open_mode != state_container.get_node("CurrentState").text.to_lower().replace(" ", "_"):
		var icon_translation = {
			"open" : 150,
			"closed" : 140,
		}
		var color_translation = {
			"open" : Color(21.0/255, 209.0/255, 59.0/255),
			"closed" : Color(62.0/255, 118.0/255, 221.0/255),
		}
		state_container.get_node("CurrentState").text = open_mode.replace("_", " ").capitalize()
		state_container.get_node("CurrentState").add_color_override("font_color", color_translation[open_mode])
		state_container.get_node("Switch").texture.region.position.x = icon_translation[open_mode]
	
	for guest in whitelist:
		if not guest_list.has_node(guest):
			var guest_instance = load("res://Scenes/SupportScenes/UI/Building/Guest/Guest.tscn").instance()
			guest_instance.name = guest
			guest_instance.get_node("Guest/Name").text = guest
			guest_list.add_child(guest_instance)
	for guest in guest_list.get_children():
		if not whitelist.has(guest.name):
			guest_list.remove_child(guest)
	
	var objects = house_data.inventory.objects
	var tiles = house_data.inventory.tiles
	tiles.merge(objects)
	var buildings = tiles
	var buildings_data = ClientData.buildings
	
	var storage_container = $StorageContainer/PanelContainer2/MarginContainer/ScrollContainer/ResizeContainer
	
	for building_name in buildings_data.keys():
		var quantity = 0
		var building_data = ClientData.GetBuilding(building_name)
		if buildings.has(building_name):
			quantity = buildings[building_name]
		
		if not storage_container.has_node(building_name):
			var building_node = load("res://Scenes/SupportScenes/UI/Building/BuildingSlot/BuildingSlot.tscn").instance()
			building_node.name = building_name
			storage_container.add_child(building_node)
		
		if (not building_data.has("achievement")) or (GameUI.account_data.has("achievements") and (GameUI.account_data.achievements.has([building_data.achievement]) and GameUI.account_data.achievements[building_data.achievement])):
			var building_node = storage_container.get_node(building_name)
			building_node.SetBuilding(building_name, quantity)
		elif building_data.has("achievement"):
			storage_container.get_node(building_name).queue_free()

func SelectBuilding(type):
	for slot in $StorageContainer/PanelContainer2/MarginContainer/ScrollContainer/ResizeContainer.get_children():
		if slot.name == "remover" and type == "remover":
			slot.modulate = Color(1,1,1)
		elif slot.name == "remover" and brush == "remover":
			slot.modulate = Color(0.51,0.51,0.51)
		elif slot.name == type:
			slot.get_node("SelectedBg").visible = true
		elif slot.name == brush:
			slot.get_node("SelectedBg").visible = false
	brush = type
	$BuildingBackground.dragging = false

func _on_Input_text_entered(new_guest):
	Server.AddGuest(new_guest)
	$PanelContainer/MarginContainer/VBoxContainer/GuestlistContainer/Input.text = ""
	$PanelContainer/MarginContainer/VBoxContainer/GuestlistContainer/Input.release_focus()
func ToggleState():
	Server.ToggleState()
func PlaceBuilding(position, type=brush):
	if type == "remover":
		Server.RemoveBuilding(position)
	else:
		Server.PlaceBuilding(type, position)
func BuildBuilding(type):
	Server.BuildBuilding(type)
