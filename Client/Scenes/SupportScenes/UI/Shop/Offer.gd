extends PanelContainer

func SetOffer(offer):
	$MarginContainer/Container/Data/HBoxContainer/Title.text = offer.title
	$MarginContainer/Container/Description.text = offer.description
	$MarginContainer/Container/PanelContainer/MarginContainer/BuyContainer/Buy.text = "%s$ USD" % [str(offer.price)]
	$MarginContainer/Container/Data/HBoxContainer/TextureRect.texture = $MarginContainer/Container/Data/HBoxContainer/TextureRect.texture.duplicate()
	$MarginContainer/Container/Data/HBoxContainer/TextureRect.texture.region = offer.icon
	$MarginContainer/Container/PanelContainer/MarginContainer/BuyContainer/Buy.connect("pressed", self, "OpenOffer", [offer.link, offer.gplay_id])

func OpenOffer(link, gplay_id):
	if PlayBilling.payment:
		PlayBilling.payment.purchase(gplay_id,"inapp","","")
	else:
		JavaScript.eval("window.open('%s')" % [link])
