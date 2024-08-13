extends CanvasLayer

var active = false
var brush = null
var inspecting_building = null

func _ready():
	$PanelContainer/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/ExitButton.connect("pressed", self, "ToggleBuilding")

func InspectBuilding(_type):
	if not _type or not ClientData.GetBuilding(_type):
		return
	
	var building = ClientData.GetBuilding(_type)
	
	var animator = $BuildingAnimations
	animator.play("InspectBuilding")
	inspecting_building = _type
	$InspectBuilding.visible = true
	
	var building_name = $InspectBuilding/MarginContainer/VBoxContainer/BuildingName
	var building_sprite = $InspectBuilding/MarginContainer/VBoxContainer/BuildingSpriteContainer/BuildingSprite
	var building_description = $InspectBuilding/MarginContainer/VBoxContainer/BuildingDescription
	var building_craftable = $InspectBuilding/MarginContainer/VBoxContainer/BuildingMaterials/Craftable
	var building_materials = $InspectBuilding/MarginContainer/VBoxContainer/BuildingMaterials/MaterialsContainer
	
	building_name.text = building.name
	building_sprite.texture.region = Rect2(building.path[3], Vector2(10, 10))
	building_description.text = building.description + "\n"
	
	var spriteTexture = load("res://Assets/"+building.path[0])
	building_sprite.texture.atlas = spriteTexture
	building_sprite.texture.region = Rect2(building.path[3], Vector2(10,10))
	
	if "tileset" in building.path[0]:
		building_sprite.material = null
	else:
		building_sprite.material = load("res://Resources/Renderer.tres")
	
	if not building.craftable:
		building_craftable.visible = true
	else:
		building_craftable.visible = false
	
	if building.craftable:
		var materials = building.materials
		
		building_materials.visible = true
		for child in building_materials.get_children():
			building_materials.remove_child(child)
		for material in materials:
			var material_instance = load("res://Scenes/SupportScenes/UI/Building/Material/Material.tscn").instance()
			material_instance.SetMaterial(material)
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
	var whitelist = house_data.whitelist
	var open_mode = house_data.open_mode
	var state_container = $PanelContainer/MarginContainer/VBoxContainer/OpenContainer
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
		state_container.get_node("Switch").texture_normal.region.position.x = icon_translation[open_mode]
	
	for guest in whitelist:
		if not guest_list.get_node(guest):
			var guest_instance = load("res://Scenes/SupportScenes/UI/Building/Guest/Guest.tscn").instance()
			guest_instance.name = guest
			guest_list.add_child(guest_instance)
	for guest in guest_list.get_children():
		if not whitelist.has(guest.name):
			guest_list.remove_child(guest)
	
	var objects = house_data.inventory.objects
	var tiles = house_data.inventory.tiles
	tiles.merge(objects)
	var buildings = tiles
	
	var storage_container = $StorageContainer/PanelContainer2/MarginContainer/ScrollContainer/ResizeContainer
	
	for building_name in buildings:
		var quantity = buildings[building_name]
		var building_data = ClientData.GetBuilding(building_name)
		
		if not storage_container.has_node(building_name):
			var building_node = load("res://Scenes/SupportScenes/UI/Building/BuildingSlot/BuildingSlot.tscn").instance()
			building_node.name = building_name
			storage_container.add_child(building_node)
		
		if (not building_data.has("achievement")) or (GameUI.account_data.has("achievements") and GameUI.account_data.achievements[building_data.achievement]):
			var building_node = storage_container.get_node(building_name)
			building_node.SetBuilding(building_name, quantity)
		elif building_data.has("achievement"):
			storage_container.get_node(building_name).queue_free()

func SelectBuilding(type):
	for slot in $StorageContainer/PanelContainer2/MarginContainer/ScrollContainer/ResizeContainer.get_children():
		if slot.name == type:
			slot.get_node("SelectedBg").visible = true
		elif slot.name == brush:
			slot.get_node("SelectedBg").visible = false
	brush = type
	$BuildingBackground.dragging = false

func PlaceBuilding(position, type=brush):
	Server.PlaceBuilding(type, position)
