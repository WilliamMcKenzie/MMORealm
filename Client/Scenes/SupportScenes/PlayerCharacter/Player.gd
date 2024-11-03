extends KinematicBody2D

#Key variables (Will set these from server immedietly)
var character

var stats
var gear
var health

var indicators = {
	"exp" : preload("res://Scenes/SupportScenes/UI/Indicators/ExpIndicator.tscn"),
	"gold" : preload("res://Scenes/SupportScenes/UI/Indicators/GoldIndicator.tscn"),
	"level" : preload("res://Scenes/SupportScenes/UI/Indicators/LevelIndicator.tscn"),
	"damage" : preload("res://Scenes/SupportScenes/UI/Indicators/DamageIndicator.tscn"),
	"ascension" : preload("res://Scenes/SupportScenes/UI/Indicators/AscensionIndicator.tscn")
}

#Sub variables (Will set these based on key variables onready)
var projectile = preload("res://Scenes/SupportScenes/Projectiles/Players/Projectile.tscn")

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
var time_between_shots = INF
var practical_speed = 0

onready var CharacterSpriteEle = $Control/CharacterSprite
onready var animation_tree = $AnimationTree

func _ready():
	$Camera2D.zoom = Vector2(0.2/Settings.zoom, 0.2/Settings.zoom)
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
		time_between_shots = (1 / (6.5 * (stats.dexterity + 17.3) / 100)) / (gear.weapon.rof/100.0)
		if character.status_effects.has("berserk"):
			time_between_shots /= (150.0/100.0)
	else:
		time_between_shots = INF
	
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
	CharacterSpriteEle.ColorGear(gear, character.class)
	lastSprite = { "R" : CharacterSpriteEle.get_region_rect(), "C" : character.class, "P" : CharacterSpriteEle.GetParams()}

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]

# warning-ignore:unused_argument
var clock_sync_timer = 0
func _physics_process(delta):
	if GameUI.is_dead:
		return
	
	clock_sync_timer += 1
	if clock_sync_timer >= 20:
		clock_sync_timer = 0
		$Camera2D.zoom = Vector2(0.2/Settings.zoom, 0.2/Settings.zoom)
		if Server.GetCurrentInstanceNode() and "dungeon_name" in Server.GetCurrentInstanceNode() and (Server.GetCurrentInstanceNode().dungeon_name == "cloud_isles" or "babel" in Server.GetCurrentInstanceNode().dungeon_name):
			$SkyBackgound.visible = true
			$BlackBackground.visible = false
		else:
			$SkyBackgound.visible = false
			$BlackBackground.visible = true
	
	UpdateStatusEffects()
	MovePlayer(delta)
	SpeedModifiers()
	DefinePlayerState()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.device == 0:
		shoot = true
		holding_shoot = true

func SpeedModifiers():
	var tilemap = get_parent().get_parent().get_node("TileMap")
	var tile_coords = tilemap.world_to_map(position)
	var tile_index = tilemap.get_cell(tile_coords.x, tile_coords.y)

	if tile_index != TileMap.INVALID_CELL and ClientData.unique_tiles.has(tile_index):
		$Control.rect_size = Vector2(20,7)
		$Control.rect_position = Vector2(-10,-6)
		practical_speed = stats.speed * ClientData.unique_tiles[tile_index]
		if ClientData.unique_tiles[tile_index] == 0:
			$Control.rect_size = Vector2(20,10)
			$Control.rect_position = Vector2(-10,-9)
			practical_speed = stats.speed
			var motion = Vector2.ZERO
			if(Input.is_action_pressed("up")):
				motion.y -= 1
			if(Input.is_action_pressed("down")):
				motion.y += 1
			if(Input.is_action_pressed("left")):
				motion.x -= 1
			if(Input.is_action_pressed("right")):
				motion.x += 1
			if left_joystick_output != Vector2.ZERO:
				motion = left_joystick_output
			
			motion = motion.normalized()
			move_and_slide(motion * -practical_speed)
	else:
		$Control.rect_size = Vector2(20,10)
		$Control.rect_position = Vector2(-10,-9)
		practical_speed = stats.speed

func UpdateStatusEffects():
	for status_node in $ZContainer/HBoxContainer/HBoxContainer.get_children():
		if character.status_effects.has(status_node.name):
			status_node.visible = true
		else:
			status_node.visible = false

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
	
	current_time - last_shot_time >= time_between_shots and shoot == true and not GameUI.is_in_menu
	
	var timing = current_time - last_shot_time >= time_between_shots
	var weapon = gear.has("weapon")
	var menu = not GameUI.is_in_menu
	
	if timing and weapon and shoot and menu:
		var i = -1
		for projectile_data in gear.weapon.projectiles:
			i += 1
			ShootProjectile(projectile_data, i)
		last_shot_time = current_time
		
	#Animations
	var shoot_direction = (get_global_mouse_position() - position).normalized()
	motion = motion.normalized()
	
	if holding_shoot == true and not GameUI.is_in_menu and left_joystick_output == Vector2.ZERO and right_joystick_output == Vector2.ZERO:
		animation_tree.get("parameters/playback").travel("Attack")
		animation_tree.set("parameters/Idle/blend_position", shoot_direction)
		animation_tree.set("parameters/Walk/blend_position", shoot_direction)
		animation_tree.set("parameters/Attack/blend_position", shoot_direction)
		lastAnimation = { "A" : "Attack", "C" : shoot_direction }
	elif right_joystick_output != Vector2.ZERO and not GameUI.is_in_menu:
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
		
	motion = move_and_slide(motion * practical_speed)
	if get_parent().get_parent().has_method("LoadChunk"):
		#Loading all possible chunks you might see around you
		var chunk_size = 16
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

func OffsetProjectileAngle(base_direction, offset_vector):
	var base_angle = base_direction.angle()
	var offset_angle = offset_vector.angle()
	var new_angle = base_angle + offset_angle
	var new_direction = Vector2(cos(new_angle), sin(new_angle))
	
	return new_direction

func ShootProjectile(projectile_data, projectile_index):
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - position).normalized()
	var damage = round(CalculateDamageWithMultiplier((rand_range(projectile_data.damage[0], projectile_data.damage[1]))))
	var offset
	
	if projectile_data.has("offset_variation"):
		randomize()
		var variation = rand_range(-projectile_data.offset_variation, projectile_data.offset_variation)
		offset = ClientData.DegreesToVector(variation)
	else:
		offset = projectile_data.offset
	
	if right_joystick_output != Vector2.ZERO:
		mouse_position = right_joystick_output*100 + position
		direction = right_joystick_output
	else:
		mouse_position = direction*100 + position
	
	#Send projectile to server
	var _projectile_data = {
		"ProjectileIndex" : projectile_index,
		"Damage" : damage,
		"Position": $Axis.global_position,
		"MousePosition": position+100*OffsetProjectileAngle(direction, offset),
		"Direction": direction,
	}
	Server.SendProjectile(_projectile_data)
	
	var start_position = $Axis.global_position + direction*3
	var pool = get_parent().get_parent().get_node_or_null("PlayerPool")
	for child in pool.get_children():
		if not child.is_active:
			child.original = true
			child.damage = damage
			child.projectile_data = {
				"name" : projectile_data["projectile"],
				"path" : start_position,
				"start_position" : start_position,
				"direction" : OffsetProjectileAngle(direction, offset),
				"tile_range" : projectile_data["tile_range"],
				"damage" : projectile_data["damage"],
				"piercing" : projectile_data["piercing"],
				"speed" : projectile_data["speed"],
				"formula" : projectile_data["formula"],
				"size" : projectile_data["size"],
			}
			child.Activate()
			break

func CalculateDamageWithMultiplier(damage):
	var base_damage = (damage*(0.5 + (float(stats.attack)/float(100))))
	var multipliers = ClientData.GetMultiplier(character.gear["weapon"].item)
	
	if multipliers.has("damage"):
		base_damage = floor(base_damage*multipliers.damage)
	if character.status_effects.has("damaging"):
		base_damage = floor(base_damage*1.25)
	
	return base_damage

func ShowIndicator(type, amount):
	var indicator = indicators[type].instance()
	var id = str(OS.get_system_time_msecs())
	
	indicator.name = id
	if type == "damage":
		AudioManager.Play("hit", amount/100)
		if amount < 0:
			indicator.get_node("Label").text = str(amount)
		else:
			indicator.queue_free()
			return
	else:
		indicator.get_node("Label").text = "+"+str(amount)
	$IndicatorPlaceholder.add_child(indicator)
	
	yield(get_tree().create_timer(1.0), "timeout")
	if is_instance_valid(indicator):
		indicator.queue_free()
