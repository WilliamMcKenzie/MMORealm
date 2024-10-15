extends Control

onready var chat_input = $PanelContainer/VBoxContainer/HBoxContainer/PanelContainer2/VBoxContainer/PanelContainer/MarginContainer/ChatInput
var chat = load("res://Scenes/SupportScenes/UI/Chat/ChatMsg.tscn")
var is_mobile = true

var interacted = false
onready var scroll_container = $PanelContainer/VBoxContainer/ScrollContainer

func _ready():
	$HiddenContainer/VBoxContainer/ScrollContainer.parent_ref = self
	$HiddenContainer/VBoxContainer/ScrollContainer/_v_scroll.connect("scrolling", self, "Interacted")
	chat_input.connect("focus_entered", self, "EnterChat")
	chat_input.connect("focus_exited", self, "ExitChat")
	
	if str(OS.get_model_name()) == 'GenericDevice':
		is_mobile = false

func Open():
	$AnimationPlayer.play("Show")
func Close():
	$AnimationPlayer.play("Hide")

func EnterChat():
	GameUI.in_chat = true
func ExitChat():
	GameUI.in_chat = false

func IdentifierToString(identifier):
	var words = identifier.split("_")
	var proper_string = ""
	for word in words:
		proper_string += word.capitalize() + " "
	
	proper_string = proper_string.strip_edges()
	return proper_string

func AddChat(message,username,classname,id):
	var chat_message = chat.instance()
	
	chat_message.get_node("From").text = "" + username + ":"
	chat_message.get_node("MarginContainer/Message").text = message
	
	if username == "Enemy":
		GameUI.UpdateEnemyChatBubbles(id, message)
		var enemy_name = classname
		var enemy_id = id
		chat_message.get_node("Icon").visible = false
		chat_message.get_node("From").add_color_override("font_color", Color(163.0/255,64.0/255,64.0/255))
		chat_message.get_node("From").text = "" + IdentifierToString(enemy_name) + ":"
		chat_message.get_node("MarginContainer/Message").add_color_override("font_color", Color(255.0/255, 184.0/255, 184.0/255))
		chat_message.get_node("MarginContainer/Message").text = "" + chat_message.get_node("MarginContainer/Message").text + ""
	elif classname:
		GameUI.UpdateChatBubbles(id, message)
		chat_message.get_node("Icon").visible = true
		chat_message.get_node("Icon").texture = chat_message.get_node("Icon").texture.duplicate()
		chat_message.get_node("Icon").texture.region = Rect2(ClientData.GetCharacter(classname).icon, Vector2(10,10))
		chat_message.get_node("From").add_color_override("font_color", Color(1,1,1).linear_interpolate(ClientData.GetCharacter(classname).color, 0.2))
	elif username == "System":
		chat_message.get_node("Icon").visible = false
		chat_message.get_node("From").text = ""
		chat_message.get_node("MarginContainer/Message").add_color_override("font_color", Color(178.0/255, 223.0/255, 230.0/255))
		chat_message.get_node("MarginContainer/Message").text = "" + chat_message.get_node("MarginContainer/Message").text + ""
	elif username == "SystemWARN":
		chat_message.get_node("Icon").visible = false
		chat_message.get_node("From").text = ""
		chat_message.get_node("MarginContainer/Message").add_color_override("font_color", Color(219.0/255, 211.0/255, 122.0/255))
		chat_message.get_node("MarginContainer/Message").text = "" + chat_message.get_node("MarginContainer/Message").text + ""
	elif username == "SystemERROR":
		chat_message.get_node("Icon").visible = false
		chat_message.get_node("From").text = ""
		chat_message.get_node("MarginContainer/Message").add_color_override("font_color", Color(219.0/255, 122.0/255, 122.0/255))
		chat_message.get_node("MarginContainer/Message").text = "" + chat_message.get_node("MarginContainer/Message").text + ""
	elif username == "SystemSUCCESS":
		chat_message.get_node("Icon").visible = false
		chat_message.get_node("From").text = ""
		chat_message.get_node("MarginContainer/Message").add_color_override("font_color", Color(122.0/255, 219.0/255, 130.0/255))
		chat_message.get_node("MarginContainer/Message").text = "" + chat_message.get_node("MarginContainer/Message").text + ""
	
	get_node("PanelContainer/VBoxContainer/ScrollContainer/ChatVerticalContainer").add_child(chat_message,1)
	
	last_added = OS.get_system_time_msecs()
	if not interacted:
		switch = true

var switch = false
var last_scroll = 0
var last_added = 0
func _physics_process(delta):
	if switch:
		scroll_container.scroll_vertical = scroll_container.get_v_scrollbar().max_value
		switch = false
	if scroll_container.scroll_vertical == scroll_container.get_v_scrollbar().max_value-140:
		interacted = false
	
	if last_scroll != scroll_container.scroll_vertical and OS.get_system_time_msecs() - last_added > 20:
		interacted = true
	last_scroll = scroll_container.scroll_vertical
	
	if(Input.is_action_just_pressed ("chat")) and chat_input.has_focus():
		chat_input.grab_focus()
		chat_input.caret_position = chat_input.text.length()
		if GameUI.is_in_menu:
			GameUI.Toggle("all")
	if(Input.is_action_just_pressed ("command")) and not chat_input.has_focus():
		if not GameUI.is_in_chat:
			GameUI.OpenChat()
		chat_input.grab_focus()
		var timer = Timer.new()
		timer.wait_time = 0.1
		timer.one_shot = true
		add_child(timer)
		timer.start()
		yield(timer, "timeout")
		
		chat_input.grab_focus()
		chat_input.text = "/"
		chat_input.caret_position = chat_input.text.length()
		if GameUI.is_in_menu and GameUI.last_menu != "trade":
			GameUI.Toggle(GameUI.last_menu)
