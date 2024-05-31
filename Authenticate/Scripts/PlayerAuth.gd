extends Node

func FetchUserData(email, password):
	var data
	if email in PlayerData.player_data:
		data = PlayerData.player_data[email]
	
	if data and data.password == password:
		print(str(data))
		return true
	else:
		print(str(data))
		print(email + "  " + password)
		return false

