extends Node2D

onready var chat_input = $HBoxContainer/ChatInput
var chat = load("res://Scenes/SupportScenes/UI/Chat/ChatMsg.tscn")

func _ready():
	chat_input.connect("focus_entered", self, "EnterChat")
	chat_input.connect("focus_exited", self, "ExitChat")

func EnterChat():
	GameUI.in_chat = true
func ExitChat():
	GameUI.in_chat = false

func AddChat(message, player):
	var chat_message = chat.instance()
	chat_message.text = ("[" + player + "]" + " : " + message)
	get_node("ChatVerticalContainer").add_child(chat_message,1)

func _physics_process(delta):
	if(Input.is_action_just_pressed ("command")):
		chat_input.grab_focus()
		chat_input.text = "/"
		chat_input.caret_position = chat_input.text.length()
