extends CanvasLayer

var offer_scene = preload("res://Scenes/SupportScenes/UI/Shop/Offer.tscn")
var offers = [
	{
		"title" : "5500 Gold",
		"description" : "5500 units of in game gold currency.",
		"price" : 50,
		"icon" : Rect2(Vector2(0,220), Vector2(10,10)),
		"gplay_id" : "5500_gold",
		"link" : "https://buy.stripe.com/bIYdT44eJ3hV0X68wB"
	},
	{
		"title" : "1000 Gold",
		"description" : "1000 units of in game gold currency.",
		"price" : 10,
		"icon" : Rect2(Vector2(0,220), Vector2(10,10)),
		"gplay_id" : "1000_gold",
		"link" : "https://buy.stripe.com/bIY02e7qV8CfbBK148"
	},
	{
		"title" : "300 Gold",
		"description" : "300 units of in game gold currency.",
		"price" : 5,
		"icon" : Rect2(Vector2(0,220), Vector2(10,10)),
		"gplay_id" : "300_gold",
		"link" : "https://buy.stripe.com/cN24iu8uZ6u70X6dQW"
	},
]

func _ready():
	$Back.connect("button_down", self, "CloseShop")
	for offer in offers:
		var offer_instance = offer_scene.instance()
		offer_instance.SetOffer(offer)
		$MarginContainer/ScrollContainer/Box.add_child(offer_instance)

func CloseShop():
	get_parent().CloseShop()
