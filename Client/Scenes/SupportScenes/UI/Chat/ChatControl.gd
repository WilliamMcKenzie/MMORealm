extends Control

onready var chat_input = $HBoxContainer/PanelContainer/MarginContainer/ChatInput
var chat = load("res://Scenes/SupportScenes/UI/Chat/ChatMsg.tscn")

func _ready():
	chat_input.connect("focus_entered", self, "EnterChat")
	chat_input.connect("focus_exited", self, "ExitChat")

func EnterChat():
	GameUI.in_chat = true
func ExitChat():
	GameUI.in_chat = false

func AddChat(message,username,classname):
	var chat_message = chat.instance()
	
	chat_message.get_node("From").text = "[" + username + "]:"
	chat_message.get_node("Message").text = message
	
	if classname:
		chat_message.get_node("Icon").visible = true
		chat_message.get_node("Icon").texture = chat_message.get_node("Icon").texture.duplicate()
		chat_message.get_node("Icon").texture.region = Rect2(ClientData.GetCharacter(classname).icon, Vector2(10,10))
		chat_message.get_node("From").add_color_override("font_color", Color(1,1,1).linear_interpolate(ClientData.GetCharacter(classname).color, 0.2))
	elif username == "System":
		chat_message.get_node("Icon").visible = false
		chat_message.get_node("From").text = ""
		chat_message.get_node("Message").add_color_override("font_color", Color(178.0/255, 223.0/255, 230.0/255))
		chat_message.get_node("Message").text = "[" + chat_message.get_node("Message").text + "]"
	
	get_node("ChatVerticalContainer").add_child(chat_message,1)

func _physics_process(delta):
	if(Input.is_action_just_pressed ("command")):
		chat_input.grab_focus()
		chat_input.text = "/"
		chat_input.caret_position = chat_input.text.length()
		if GameUI.is_inventory_open == true:
			GameUI.ToggleInventory()
		if GameUI.is_stats_open == true:
			GameUI.ToggleStats()
		if GameUI.is_classes_open == true:
			GameUI.ToggleClasses()
