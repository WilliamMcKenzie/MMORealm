extends Control

func ChangeHealth(max_health, health):
	var difference = health - get_node("HealthBar").value
	if difference < 1:
		Server.get_node("../SceneHandler/"+Server.GetCurrentInstance()+"/YSort/player").ShowIndicator("damage", difference)
	
	get_node("HealthBar").max_value = max_health
	get_node("HealthBar").value = health
	get_node("HealthBar").rect_min_size.x = 150 + health/50
