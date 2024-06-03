extends KinematicBody2D

onready var animationTree = $AnimationTree
var projectile_dict = {}

func _physics_process(delta):
	if projectile_dict != {}:
		ShootProjectile()

func MovePlayer(new_position, animation):
	set_position(new_position)
	
	if animation is Dictionary and animation.has("A") and animation.has("C"):
		var animationType = animation["A"]
		var animationDirection = animation["C"]
		
		animationTree.get("parameters/playback").travel(animationType)
		animationTree.set("parameters/Idle/blend_position", animationDirection)
		animationTree.set("parameters/Walk/blend_position", animationDirection)
		animationTree.set("parameters/Attack/blend_position", animationDirection)

func ShootProjectile():
	for projectile_time in projectile_dict.keys():
		if projectile_time <= OS.get_system_time_msecs():
			var projectile_data = projectile_dict[projectile_time]
			var projectile_node = load("res://Scenes/SupportScenes/Projectiles/" + str(projectile_data["Projectile"]) + "/" + str(projectile_data["Projectile"]) + ".tscn")
			var projectile_instance = projectile_node.instance()
			projectile_instance.position = $Axis.global_position
			
			#Set projectile data
			projectile_instance.damage = projectile_data["Damage"]
			projectile_instance.tile_range = projectile_data["TileRange"]
			projectile_instance.set_direction(projectile_data["Direction"])
			projectile_instance.look_at(projectile_data["MousePosition"])
			projectile_instance.original = false
			projectile_dict.erase(projectile_time)
			get_parent().add_child(projectile_instance)
