extends Node

func FetchProjectileData(skill_name):
	var data = ServerData.projectile_data[skill_name]
	return data
