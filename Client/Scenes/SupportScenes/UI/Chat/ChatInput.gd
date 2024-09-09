extends LineEdit

func _on_ChatInput_text_entered(new_text):
	Server.SendChatMessage(new_text)
	text = ""
	release_focus()
