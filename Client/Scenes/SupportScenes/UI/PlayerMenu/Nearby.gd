extends CanvasLayer

var player_node = load("res://Scenes/SupportScenes/UI/PlayerMenu/Player.tscn")
var active = false

var viewing_player = false
var viewing_player_name = ""

func _ready():
	$NearbyBackground.connect("button_down", self, "ToggleNearby")
	$NearbyContainer/CloseButton.connect("pressed", self, "ToggleNearby")
	
	$PlayerMenu/PanelContainer2/MarginContainer/ResizeContainer/Options/Teleport.connect("pressed", self, "Teleport")
	$PlayerMenu/PanelContainer2/MarginContainer/ResizeContainer/Options/Trade.connect("pressed", self, "Trade")

func Teleport():
	Server.SendChatMessage("/tp " + viewing_player_name)
func Trade():
	Server.SendChatMessage("/trade " + viewing_player_name)

var sync_clock_counter = 0
func _physics_process(delta):
	if not active:
		return
	GameUI.NearbyToggleLogic()
	sync_clock_counter += 1
	if sync_clock_counter > 30:
		sync_clock_counter = 0
		var other_players_nodes = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/OtherPlayers").get_children()
		
		if other_players_nodes.size() > 0:
			get_node("NearbyContainer/PanelContainer2/MarginContainer/ResizeContainer/None").visible = false
			var other_players_ids = []
			other_players_nodes = SortNodesByDistance(other_players_nodes)
			
			for node in other_players_nodes:
				other_players_ids.append(node.name)
			Server.FetchBatchCharacterData(other_players_ids)
		else:
			var nearby_players_node = get_node("NearbyContainer/PanelContainer2/MarginContainer/ResizeContainer/NearbyPlayers")
			for child in nearby_players_node.get_children():
				if child.name != "None":
					nearby_players_node.remove_child(child)
			get_node("NearbyContainer/PanelContainer2/MarginContainer/ResizeContainer/None").visible = true

func OpenPlayerMenu(id, character_data):
	var player_menu_node = get_node("PlayerMenu")
	
	if viewing_player and viewing_player_name == character_data.name:
		player_menu_node.visible = false
		viewing_player = false
		return
	else:
		player_menu_node.visible = true
		viewing_player = true
		viewing_player_name = character_data.name
	
	var name_node = player_menu_node.get_node("PanelContainer2/MarginContainer/ResizeContainer/CharacterInfo/Name")
	var character_sprite = player_menu_node.get_node("PanelContainer2/MarginContainer/ResizeContainer/CharacterInfo/Character/MarginContainer/Sprite")
	var info_node = player_menu_node.get_node("PanelContainer2/MarginContainer/ResizeContainer/CharacterInfo/Character/Info")
	var info_text = ""
	
	if character_data.level > 20:
		info_text = "Level 20 " + character_data.class
	else:
		info_text = "Level " + str(character_data.level) + " " + character_data.class
	
	player_menu_node.visible = true
	name_node.text = character_data.name
	info_node.text = info_text
	UtilityFunctions.SetCharacterSprite(character_data, character_sprite)

class CompareDistances:
	static func compare_distances(a, b):
		var target_position = Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player").position
		var dist_a = a.position.distance_to(target_position)
		var dist_b = b.position.distance_to(target_position)
		return dist_a < dist_b
func SortNodesByDistance(nodes_array):
	nodes_array.sort_custom(CompareDistances, "compare_distances")
	return nodes_array

func SetCharacters(characters_data):
	var nearby_players_node = get_node("NearbyContainer/PanelContainer2/MarginContainer/ResizeContainer/NearbyPlayers")
	for child in nearby_players_node.get_children():
		nearby_players_node.remove_child(child)
	
	var index = 0
	for character_data in characters_data:
		if not character_data.name:
			continue
		
		index += 1
		var player_instance = player_node.instance()
		
		player_instance.index = index
		player_instance.name = character_data.name
		player_instance.SetCharacter(character_data)
		nearby_players_node.add_child(player_instance)

func ToggleNearby():
	get_parent().Toggle("nearby")

func Open():
	sync_clock_counter = 60
	active = true
	var nearby_tween = $NearbyTween
	var nearby_element = $NearbyContainer
	var player_menu_tween = $PlayerMenuTween
	var player_menu_element = $PlayerMenu
	
	nearby_tween.interpolate_property(nearby_element, "rect_position", nearby_element.rect_position, Vector2(-280, 0)+nearby_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	nearby_tween.start()
	
	player_menu_tween.interpolate_property(player_menu_element, "rect_position", player_menu_element.rect_position, Vector2(280, 0)+player_menu_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	player_menu_tween.start()
	
	var timer = Timer.new()
	timer.wait_time = 0.4
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	$NearbyBackground.visible = true

func Close():
	active = false
	viewing_player = false
	get_node("PlayerMenu").visible = false
	
	var nearby_tween = $NearbyTween
	var nearby_element = $NearbyContainer
	var player_menu_tween = $PlayerMenuTween
	var player_menu_element = $PlayerMenu
	
	nearby_tween.interpolate_property(nearby_element, "rect_position", nearby_element.rect_position, Vector2(280, 0)+nearby_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	nearby_tween.start()
	
	player_menu_tween.interpolate_property(player_menu_element, "rect_position", player_menu_element.rect_position, Vector2(-280, 0)+player_menu_element.rect_position, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	player_menu_tween.start()
	
	$NearbyBackground.visible = false
