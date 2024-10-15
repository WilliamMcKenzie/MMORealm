extends Label

func _physics_process(delta):
	if Settings.show_ping:
		set_text("Ping " + str(Server.server_delay))
	else:
		set_text("")
