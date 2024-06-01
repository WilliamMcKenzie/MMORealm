extends LineEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function bo

func _on_ChatInput_text_entered(new_text):
	Server.SendChatMessage(new_text)
	text = ""
	release_focus()
