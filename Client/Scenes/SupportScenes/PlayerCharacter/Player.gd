extends KinematicBody2D

#Key variables (Will set these from server immedietly)
var level
var stats
var gear

onready var WeaponSlot = $PlayerUI/Gear/Weapon
onready var AbilitySlot = $PlayerUI/Gear/Ability
onready var ArmorSlot = $PlayerUI/Gear/Armor
onready var RingSlot = $PlayerUI/Gear/Ring

#Sub variables (Will set these based on key variables onready)
var projectile

var x = 0
var y = 0

#We send animation to server to display to other clients.
var lastAnimation = { "A" : "Idle", "C" : Vector2.ZERO }


var shoot = false
var last_shot_time = 0
onready var animationTree = $AnimationTree

func _ready():
	var projectile_path = "res://Scenes/SupportScenes/Projectiles/" + str(gear.weapon.projectile) + "/" + str(gear.weapon.projectile) + ".tscn"
	projectile = load(projectile_path)
	PopulateInventory()

func PopulateInventory():
	SetSpriteData(WeaponSlot, gear.weapon.path)
	SetSpriteData(AbilitySlot, gear.ability.path)
	SetSpriteData(ArmorSlot, gear.armor.path)
	SetSpriteData(RingSlot, gear.ring.path)
func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame = path[3]
# warning-ignore:unused_argument
func _physics_process(delta):
	MovePlayer(delta)
	DefinePlayerState()

func MovePlayer(delta):
	var motion = Vector2.ZERO
	# remember to add checks to make sure each input is only hit once, emulators may be able to simulate multiple action pressed inputs
	if(Input.is_action_just_pressed ("up")):
		y -= 1
	if(Input.is_action_just_pressed ("down")):
		y += 1
	if(Input.is_action_just_pressed ("left")):
		x -= 1
	if(Input.is_action_just_pressed ("right")):
		x += 1
		
	if(Input.is_action_just_released("up")):
		y += 1
	if(Input.is_action_just_released ("down")):
		y -= 1
	if(Input.is_action_just_released ("left")):
		x += 1
	if(Input.is_action_just_released ("right")):
		x -= 1

	if(Input.is_action_just_pressed("shoot")):
		shoot = true
	if (Input.is_action_just_released("shoot")):
		shoot = false
	if (Input.is_action_just_pressed("nexus")):
		Server.Nexus()

	motion.x += x
	motion.y += y
	
	var current_time = OS.get_ticks_msec() / 1000.0
	var time_between_shots = 1 / (6.5 * (stats.dexterity + 17.3) / 75)
	if current_time - last_shot_time >= time_between_shots and shoot == true:
		ShootProjectile()
		last_shot_time = current_time
		
	#Animations
	var shoot_direction = (get_global_mouse_position() - global_position).normalized()
	if Input.is_action_pressed("shoot"):
		animationTree.get("parameters/playback").travel("Attack")
		animationTree.set("parameters/Idle/blend_position", shoot_direction)
		animationTree.set("parameters/Attack/blend_position", shoot_direction)
		lastAnimation = { "A" : "Attack", "C" : shoot_direction }
	elif motion != Vector2.ZERO:
		animationTree.get("parameters/playback").travel("Walk")
		animationTree.set("parameters/Idle/blend_position", motion)
		animationTree.set("parameters/Walk/blend_position", motion)
		lastAnimation = { "A" : "Walk", "C" : motion }
	else:
		animationTree.get("parameters/playback").travel("Idle")
		lastAnimation["A"] = "Idle"
	motion = motion.normalized()
	motion = move_and_slide(motion * stats.speed)

#Here we are sending over the location to the server 60 times a second
func DefinePlayerState():
	var player_state = {"T":OS.get_system_time_msecs(), "P":get_global_position(), "A":lastAnimation}
	Server.SendPlayerState(player_state)

func ShootProjectile():
	var projectile_instance = projectile.instance()
	projectile_instance.position = $Axis.global_position
	
	#Set projectile data
	projectile_instance.damage = round(CalculateDamageWithMultiplier((rand_range(gear.weapon.damage[0], gear.weapon.damage[1]))))
	projectile_instance.tile_range = gear.weapon.range
	
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - position).normalized()
	projectile_instance.set_direction(direction)
	projectile_instance.look_at(mouse_position)
	get_parent().add_child(projectile_instance)

func CalculateDamageWithMultiplier(damage):
	return (damage*(0.5 + (float(stats.attack)/float(50))))
