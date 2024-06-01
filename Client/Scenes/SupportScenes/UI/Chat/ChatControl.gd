extends Node2D

# var b = "text"
var Chat = load("res://Scenes/SupportScenes/UI/Chat/ChatMsg.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func AddChat(msg,plr):
	var ChatMsg = Chat.instance()
	ChatMsg.text = ("[" + plr + "]" + " : " + msg)
	get_node("ChatVerticalContainer").add_child(ChatMsg,1)
	get_node("ChatVerticalContainer").move_child(ChatMsg,1)
