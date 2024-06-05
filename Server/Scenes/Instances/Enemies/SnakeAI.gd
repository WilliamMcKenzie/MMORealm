extends Node2D



func DealDamage(damage):
	print(damage)
	print("Hit: " + str(get_parent().get_parent().get_parent().enemy_list[name]["Health"]))
	get_parent().get_parent().get_parent().enemy_list[name]["Health"] -= damage
	if get_parent().get_parent().get_parent().enemy_list[name]["Health"] < 1:
		queue_free()
