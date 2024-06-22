extends PanelContainer

var loot = null
var id = null

func _ready():
	$MarginContainer/TextureButton.connect("pressed", self, "OpenLootBag")

func ActivateLootButton(_id, _loot):
	id = _id
	loot = _loot
	visible = true
	GameUI.get_node("Inventory").SetLoot(id, loot)

func DisableLootButton():
	id = null
	loot = null
	visible = false
	GameUI.get_node("Inventory").SetLoot(null, null)
	
func OpenLootBag():
	GameUI.get_node("Inventory").ToggleInventory()
