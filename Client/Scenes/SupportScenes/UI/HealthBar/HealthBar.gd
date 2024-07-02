extends Control

func ChangeHealth(max_health, health):
	get_node("HealthBar").max_value = max_health
	get_node("HealthBar").value = health
