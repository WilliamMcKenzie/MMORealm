extends KinematicBody2D

#Key variables (Will set these from server immedietly)
var level
var stats
var gear

onready var WeaponSlot = $PlayerUI/Weapon
onready var AbilitySlot = $PlayerUI/Ability
onready var ArmorSlot = $PlayerUI/Armor
onready var RingSlot = $PlayerUI/Ring

#Sub variables (Will set these based on key variables onready)
var projectile

var last_shot_time = 0
onready var animationTree = $AnimationTree

func _ready():
	var projectilePath = "res://Scenes/SupportScenes/Projectiles/" + str(gear.weapon.projectile) + "/" + str(gear.weapon.projectile) + ".tscn"
	projectile = load(projectilePath)
	populate_inventory()

func populate_inventory():
	setSpriteData(WeaponSlot, gear.weapon.path)
	setSpriteData(AbilitySlot, gear.ability.path)
	setSpriteData(ArmorSlot, gear.armor.path)
	setSpriteData(RingSlot, gear.ring.path)
func setSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame = path[3]

func _physics_process(delta):
	
	var motion = Vector2.ZERO

	if(Input.is_action_pressed("up")):
		motion.y -= 1
	if(Input.is_action_pressed("down")):
		motion.y += 1
	if(Input.is_action_pressed("left")):
		motion.x -= 1
	if(Input.is_action_pressed("right")):
		motion.x += 1
	if(Input.is_action_pressed("shoot")):
		var current_time = OS.get_ticks_msec() / 1000.0
		var time_between_shots = 1 / (2 + (6 * (stats.dexterity/2)) / 75.0)
		if current_time - last_shot_time >= time_between_shots:
			shoot_projectile()
			last_shot_time = current_time
	motion = motion.normalized()
	
	#Animations
	if(Input.is_action_pressed("shoot")):
		animationTree.get("parameters/playback").travel("Attack")
		animationTree.set("parameters/Idle/blend_position", (get_global_mouse_position()-global_position).normalized())
		animationTree.set("parameters/Walk/blend_position", (get_global_mouse_position()-global_position).normalized())
		animationTree.set("parameters/Attack/blend_position", (get_global_mouse_position()-global_position).normalized())
	elif motion != Vector2.ZERO:
		animationTree.get("parameters/playback").travel("Walk")
		animationTree.set("parameters/Idle/blend_position", motion)
		animationTree.set("parameters/Walk/blend_position", motion)
	else:
		animationTree.get("parameters/playback").travel("Idle")
	motion = move_and_slide(motion * stats.speed)

func shoot_projectile():
	var projectile_instance = projectile.instance()
	projectile_instance.position = $Axis.global_position
	
	#Set projectile data
	projectile_instance.damage = round(calculateDamageWithMultiplier((rand_range(gear.weapon.damage[0], gear.weapon.damage[1]))))
	projectile_instance.tile_range = gear.weapon.range
	
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - position).normalized()
	projectile_instance.set_direction(direction)
	projectile_instance.look_at(mouse_position)
	get_parent().add_child(projectile_instance)

func calculateDamageWithMultiplier(damage):
	return (damage*(0.5 + (float(stats.attack)/float(50))))
