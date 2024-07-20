extends VBoxContainer

var current_requester = null

func _ready():
	$HBoxContainer/AcceptRequest.connect("button_down", self, "Accept")
	$HBoxContainer/RejectRequest.connect("button_down", self, "Reject")
	
func Open(player_name):
	visible = true
	current_requester = player_name
	$Label.text = current_requester + " wants to trade"
	
func Accept():
	get_node("/root/Server").AcceptTrade(current_requester)
	visible = false
	current_requester = null
	
func Reject():
	visible = false
	current_requester = null
