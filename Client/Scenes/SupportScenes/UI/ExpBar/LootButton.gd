extends PanelContainer

var loot_bags = {}
var loot = null
var id = null

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenLootBag")

func _physics_process(delta):
	if loot_bags.empty():
		loot = null
		id = null
		visible = false
		GameUI.get_node("Inventory").SetLoot(null, null)
	else:
		visible = true
		
		var min_position = -1
		var min_tier = -1
		
		var _loot = null
		var _id = null
		
		for object_id in loot_bags:
			var player_position = Server.get_node("../SceneHandler/" + Server.GetCurrentInstance() + "/YSort/player").position
			var loot_bag_position = loot_bags[object_id]["Position"]
			var distance = (player_position - loot_bag_position).length()
			var tier = loot_bags[object_id]["Tier"]
			
			if tier == min_tier and distance > min_position:
				_loot = loot_bags[object_id]["Loot"]
				_id = object_id
				min_position = distance
			if tier > min_tier:
				min_tier = tier
				_loot = loot_bags[object_id]["Loot"]
				_id = object_id
			
			print(min_tier)
		
		if _loot and loot != _loot:
			loot = _loot
			id = _id
			GameUI.get_node("Inventory").SetLoot(id, loot)

func ActivateLootButton(_id, _loot, _tier, _position):
	loot_bags[_id] = {
		"Loot" : _loot,
		"Tier" : _tier,
		"Position" : _position,
	}

func DisableLootButton(_id):
	loot_bags.erase(_id)
	
func OpenLootBag():
	GameUI.get_node("Inventory").ToggleInventory()
