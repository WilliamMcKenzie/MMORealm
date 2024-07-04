extends KinematicBody2D

#Key variables (Will set these from server immedietly)
var character

var stats
var gear
var health

var exp_indicator_scene = preload("res://Scenes/SupportScenes/UI/ExpIndicator/ExpIndicator.tscn")
var level_indicator_scene = preload("res://Scenes/SupportScenes/UI/LevelIndicator/LevelIndicator.tscn")

#Sub variables (Will set these based on key variables onready)
var projectile

var x = 0
var y = 0

#For the joysticks
var left_joystick_output = Vector2.ZERO
var right_joystick_output = Vector2.ZERO
var holding_shoot = false

#We send animation to server to display to other clients.
var lastAnimation = { "A" : "Idle", "C" : Vector2.ZERO }
var lastSprite = { "R" : Rect2(Vector2(0,0), Vector2(80,40)), "C" : "Apprentice", "P" : {}}

var shoot = false
var last_shot_time = 0
onready var CharacterSpriteEle = $CharacterSprite
onready var animation_tree = $AnimationTree

func _ready():
	if gear.has("weapon") and gear.weapon.has("projectile"):
		var projectile_type = gear.weapon.projectile
		var projectile_path = "res://Scenes/SupportScenes/Projectiles/Players/" + str(projectile_type) + ".tscn"
		projectile = load(projectile_path)

	SetCharacterSprite()

#Dealing with the characters sprite
func SetCharacter(_character):
	var same = character and character.hash() == _character.hash()
	if character and same:
		return
	
	character = _character
	
	stats = character.stats
	gear = {}
	
	for slot in character.gear.keys():
		if character.gear[slot] != null:
			gear[slot] = ClientData.GetItem(int(character.gear[slot].item), true)
			for stat in gear[slot].stats.keys():
				stats[stat] += gear[slot].stats[stat]
	
	if gear.has("weapon"):
		var projectile_type = gear.weapon.projectile
		var projectile_path = "res://Scenes/SupportScenes/Projectiles/Players/" + str(projectile_type) + ".tscn"
		projectile = load(projectile_path)
	
	if is_inside_tree():
		SetCharacterSprite()

func UpdateCharacter(_character):
	character = _character
	
	stats = character.stats
	gear = character.gear
	health = character.health

func SetCharacterSprite():
	CharacterSpriteEle.SetCharacterClass(character.class)
	if character.gear["weapon"] != null:
		var weapon = ClientData.GetItem(character.gear.weapon.item, true)
		if weapon != null:
			CharacterSpriteEle.SetCharacterWeapon(weapon.type)
	SetSpriteData(CharacterSpriteEle, ClientData.GetCharacter(character.class).path)
	CharacterSpriteEle.ColorGear(gear)
	lastSprite = { "R" : $CharacterSprite.get_region_rect(), "C" : character.class, "P" : CharacterSpriteEle.GetParams()}

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]

# warning-ignore:unused_argument
func _physics_process(delta):
	MovePlayer(delta)
	DefinePlayerState()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		shoot = true
		holding_shoot = true
		
func MovePlayer(delta):
	if GameUI.in_chat == true:
		return
	var motion = Vector2.ZERO
	x = 0
	y = 0

	# remember to add checks to make sure each input is only hit once, emulators may be able to simulate multiple action pressed inputs
	if(Input.is_action_pressed("up")):
		y -= 1
	if(Input.is_action_pressed("down")):
		y += 1
	if(Input.is_action_pressed("left")):
		x -= 1
	if(Input.is_action_pressed("right")):
		x += 1
	if left_joystick_output != Vector2.ZERO:
		motion = left_joystick_output

	if (Input.is_action_just_released("shoot")):
		shoot = false
		holding_shoot = false
	if right_joystick_output != Vector2.ZERO:
		shoot = true
	if right_joystick_output == Vector2.ZERO and holding_shoot == false:
		shoot = false
	if holding_shoot == true and (left_joystick_output != Vector2.ZERO or right_joystick_output != Vector2.ZERO):
		shoot = false
		holding_shoot = false
	
	if (Input.is_action_just_pressed("nexus")):
		Server.Nexus()

	motion.x += x
	motion.y += y
	
	var current_time = OS.get_ticks_msec() / 1000.0
	
	if gear.has("weapon"):
		var time_between_shots = (1 / (6.5 * (stats.dexterity + 17.3) / 75)) / (gear.weapon.rof/100)
		if current_time - last_shot_time >= time_between_shots and shoot == true and not GameUI.is_inventory_open:
			ShootProjectile()
			last_shot_time = current_time
		
	#Animations
	var shoot_direction = (get_global_mouse_position() - position).normalized()
	motion = motion.normalized()
	
	if holding_shoot == true and not GameUI.is_inventory_open and left_joystick_output == Vector2.ZERO and right_joystick_output == Vector2.ZERO:
		animation_tree.get("parameters/playback").travel("Attack")
		animation_tree.set("parameters/Idle/blend_position", shoot_direction)
		animation_tree.set("parameters/Walk/blend_position", shoot_direction)
		animation_tree.set("parameters/Attack/blend_position", shoot_direction)
		lastAnimation = { "A" : "Attack", "C" : shoot_direction }
	elif right_joystick_output != Vector2.ZERO and not GameUI.is_inventory_open:
		animation_tree.get("parameters/playback").travel("Attack")
		animation_tree.set("parameters/Idle/blend_position", right_joystick_output)
		animation_tree.set("parameters/Walk/blend_position", right_joystick_output)
		animation_tree.set("parameters/Attack/blend_position", right_joystick_output)
		lastAnimation = { "A" : "Attack", "C" : right_joystick_output }
	elif motion != Vector2.ZERO:
		animation_tree.get("parameters/playback").travel("Walk")
		animation_tree.set("parameters/Idle/blend_position", motion)
		animation_tree.set("parameters/Walk/blend_position", motion)
		animation_tree.set("parameters/Attack/blend_position", motion)
		lastAnimation = { "A" : "Walk", "C" : motion }
	else:
		animation_tree.get("parameters/playback").travel("Idle")
		lastAnimation["A"] = "Idle"
		
	motion = move_and_slide(motion * stats.speed)
	if get_parent().get_parent().has_method("LoadChunk"):
		#Loading all possible chunks you might see around you
		var chunk_size = 32
		get_parent().get_parent().LoadChunk(position, Vector2(0, 0))
		get_parent().get_parent().LoadChunk(position, Vector2(chunk_size, 0))
		get_parent().get_parent().LoadChunk(position, Vector2(chunk_size, chunk_size))
		get_parent().get_parent().LoadChunk(position, Vector2(-chunk_size, 0))
		get_parent().get_parent().LoadChunk(position, Vector2(-chunk_size, chunk_size))
		get_parent().get_parent().LoadChunk(position, Vector2(0, chunk_size))
		get_parent().get_parent().LoadChunk(position, Vector2(chunk_size, -chunk_size))
		get_parent().get_parent().LoadChunk(position, Vector2(0, -chunk_size))
		get_parent().get_parent().LoadChunk(position, Vector2(-chunk_size, -chunk_size))

#Here we are sending over the location to the server 60 times a second
func DefinePlayerState():
	var player_state = {"T":OS.get_system_time_msecs(), "P":get_global_position(), "A":lastAnimation, "S":lastSprite}
	Server.SendPlayerState(player_state)

func ShootProjectile():
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - position).normalized()
	var projectile_instance = projectile.instance()
	var damage = round(CalculateDamageWithMultiplier((rand_range(gear.weapon.damage[0], gear.weapon.damage[1]))))
	
	if right_joystick_output != Vector2.ZERO:
		mouse_position = right_joystick_output*100 + position
		direction = right_joystick_output
	else:
		mouse_position = direction*100 + position
	
	#Send projectile to server
	var projectile_data = {
		"Damage" : damage,
		"Projectile":gear.weapon.projectile,
		"Position":$Axis.global_position,
		"MousePosition":mouse_position,
		"Direction":direction,
		"TileRange":gear.weapon.range
	}
	Server.SendProjectile(projectile_data)
	
	projectile_instance.position = $Axis.global_position + direction*3
	
	#Set projectile data
	projectile_instance.projectile = gear.weapon.projectile
	projectile_instance.damage = damage
	projectile_instance.tile_range = gear.weapon.range
	
	projectile_instance.set_direction(direction)
	get_parent().add_child(projectile_instance)
	get_parent().get_node(projectile_instance.name).look_at(mouse_position)

func CalculateDamageWithMultiplier(damage):
	return (damage*(0.5 + (float(stats.attack)/float(50))))

func ShowExpIndicator(exp_amount):
	var exp_indicator = exp_indicator_scene.instance()
	var id = str(OS.get_system_time_msecs())
	exp_indicator.get_node("ExpLabel").text = "+"+str(exp_amount)
	exp_indicator.position = Vector2(-4,-8)
	exp_indicator.name = id
	
	add_child(exp_indicator)

	var timer = Timer.new()
	timer.wait_time = 1
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	if is_instance_valid(get_node(id)): 
		get_node(id).queue_free()

func ShowLevelIndicator(level):
	var level_indicator = level_indicator_scene.instance()
	var id = str(OS.get_system_time_msecs())
	level_indicator.position = Vector2(-4,-8)
	level_indicator.name = id
	
	add_child(level_indicator)

	var timer = Timer.new()
	timer.wait_time = 1
	timer.one_shot = true
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	
	if is_instance_valid(get_node(id)): 
		get_node(id).queue_free()
