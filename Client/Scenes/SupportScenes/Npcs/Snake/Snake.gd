extends Node2D

var distanceTraveled
var velocity = Vector2.ZERO

var damageIndicatorScene = preload("res://Scenes/SupportScenes/UI/DamageIndicator/DamageIndicator.tscn")

func _ready():
	$Area2D.connect("area_entered", self, "OnHit")

func MoveEnemy(new_position):
	set_position(new_position)

#Damage Taken section
func OnHit(body):
	if ("damage" in body.get_parent()):
		ShowDamageIndicator(-1*body.get_parent().damage)
		body.get_parent().interaction(self)
	if ("original" in body.get_parent()) and (body.get_parent().original == true):
		Server.NPCHit(get_name(), body.get_parent().damage)

func ShowDamageIndicator(damage_amount):
	var damage_indicator = damageIndicatorScene.instance()
	damage_indicator.get_node("DamageLabel").text = str(damage_amount)
	damage_indicator.position = damage_indicator.position + Vector2(10, -10)
	
	add_child(damage_indicator)

	var timer = Timer.new()
	timer.wait_time = 1.0 # Adjust this as needed
	timer.one_shot = true
	add_child(timer)
	timer.start()

	timer.connect("timeout", self, "DamageIndicatorTimeout")

func DamageIndicatorTimeout():
	if is_instance_valid(get_node("DamageIndicator")): 
		get_node("DamageIndicator").queue_free()
