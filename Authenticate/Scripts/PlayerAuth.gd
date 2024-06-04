extends Node

func FetchUserData(email, password):
	#Until we have access to database, when running on a private server it dosent have access to playerdata
	return true
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

