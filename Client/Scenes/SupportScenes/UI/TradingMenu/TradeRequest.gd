extends VBoxContainer

var current_requester = null

#func _physics_process(delta):
	#if GameUI.get_node("TradingMenu").visible:
		#Reject()

func _ready():
	$HBoxContainer/AcceptRequest.connect("button_down", self, "Accept")
	$HBoxContainer/RejectRequest.connect("button_down", self, "Reject")
	
func Open(player_name):
	if player_name != current_requester:
		visible = true
		current_requester = player_name
		$Label.text = current_requester + " wants to trade"
	
func Accept():
	get_node("/root/Server").AcceptTrade(current_requester)
	visible = false
	
func Reject():
	visible = false
	current_requester = null
