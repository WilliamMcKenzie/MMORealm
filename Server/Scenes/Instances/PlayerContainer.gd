extends Node

var email = "niegel"
var character

var health = 100

var stats = {
	"health" : 100
}

func DealDamage(damage, enemy_id):
	health -= damage
	get_node("/root/Server").SetHealth(int(name), 100, health)
	if health < 1:
		Death(enemy_id)

func Death(enemy_id):
	get_parent().get_parent().get_parent().player_list.erase(name)
	get_node("/root/Server").NotifyDeath(int(name), enemy_id)
	queue_free()

func _on_PlayerHitbox_area_entered(area):
	if "enemy_id" in area.get_parent():
		DealDamage(area.get_parent().damage, area.get_parent().enemy_id)
