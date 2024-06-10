extends Node2D

var distanceTraveled
var velocity = Vector2.ZERO

var damageIndicatorScene = preload("res://Scenes/SupportScenes/UI/DamageIndicator/DamageIndicator.tscn")
var projectile_dict = {}

func _physics_process(delta):
	if projectile_dict != {}:
		ShootProjectile()

func _ready():
	$Area2D.connect("area_entered", self, "OnHit")

func MoveEnemy(new_position):
	set_position(new_position)

func ShootProjectile():
	for projectile_time in projectile_dict.keys():
		if projectile_time <= OS.get_system_time_msecs():
			var projectile_data = projectile_dict[projectile_time]
			var projectile_node = load("res://Scenes/SupportScenes/Projectiles/Enemies/" + str(projectile_data["Projectile"]) + "/" + str(projectile_data["Projectile"]) + ".tscn")
			var projectile_instance = projectile_node.instance()
			projectile_instance.position = projectile_data["Position"]
			
			#Set projectile data
			projectile_instance.damage = projectile_data["Damage"]
			projectile_instance.tile_range = projectile_data["TileRange"]
			projectile_instance.set_direction(projectile_data["Direction"])
			projectile_instance.look_at(projectile_data["TargetPosition"])
			projectile_dict.erase(projectile_time)
			get_parent().get_parent().add_child(projectile_instance)
			get_parent().get_parent().get_node(projectile_instance.name).look_at(projectile_data["TargetPosition"])

#Damage Taken section
func OnHit(body):
	if ("damage" in body.get_parent()):
		ShowDamageIndicator(-1*body.get_parent().damage)
		body.get_parent().interaction(self)

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
