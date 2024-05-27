extends Node2D

var distanceTraveled
var health = 20
var speed = 50
var playersWhoDamaged = []
var velocity = Vector2.ZERO

var damageIndicatorScene = preload("res://Scenes/SupportScenes/UI/DamageIndicator/DamageIndicator.tscn")

func _ready():
	$Area2D.connect("area_entered", self, "onHit")

#Damage Taken section
func onHit(body):
	print("Collision")
	if body.get_parent().has_method("playerProjectile"):
		body.get_parent().interaction(true)
		health -= body.get_parent().damage
		if health <= 0:
			die()
		else:
			show_damage_indicator(-5)

func show_damage_indicator(damage_amount):
	var damage_indicator = damageIndicatorScene.instance()
	damage_indicator.get_node("DamageLabel").text = str(damage_amount)
	damage_indicator.position = damage_indicator.position + Vector2(10, -10)
	
	add_child(damage_indicator)

	var timer = Timer.new()
	timer.wait_time = 1.0 # Adjust this as needed
	timer.one_shot = true
	add_child(timer)
	timer.start()

	timer.connect("timeout", self, "_on_damage_indicator_timeout")

func _on_damage_indicator_timeout():
	get_node("DamageIndicator").queue_free()

func die():
	queue_free()
	print("I died")
	
func dropLoot():
	pass
	# Instantiate loot items at the enemy's position
	# Example: 
	# var loot_instance = loot_scene.instance()
	# loot_instance.position = position
	# get_parent().add_child(loot_instance)
