extends Control

onready var ContainerButton = $Create
onready var price = 500 + (get_parent().character_slots*200)

func _ready():
	$PanelContainer/MarginContainer/VBoxContainer/Cost.text = str(price) + " Gold"
	if price > get_parent().get_parent().gold:
		$Create.modulate.a = 0.4
	ContainerButton.connect("pressed", self, "BuyCharacterSlot")

func BuyCharacterSlot():
	var home_node = get_parent().get_parent()
	var email = home_node.email
	var password = home_node.password
	
	if home_node.gold >= price:
		Gateway.ConnectToServer(email, password, 3)
