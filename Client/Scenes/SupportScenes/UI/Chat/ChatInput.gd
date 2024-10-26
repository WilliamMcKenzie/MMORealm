extends LineEdit

func _on_ChatInput_text_entered(new_text):
	GameUI.get_node("ChatControl").last_sent = OS.get_system_time_msecs()
	Server.SendChatMessage(new_text)
	text = ""
	release_focus()
