extends Node

func OffsetProjectileAngle(base_direction, offset_vector):
	var base_angle = base_direction.angle()
	var offset_angle = offset_vector.angle()
	var new_angle = base_angle + offset_angle
	var new_direction = Vector2(cos(new_angle), sin(new_angle))
	
	return new_direction
func RgbToColor(r, g, b):
	return Color(r/255, g/255, b/255)
func RgbaToColor(r, g, b, a):
	return Color(r/255, g/255, b/255, a)
func DecorateFake(player_state, character, gear):
	player_state["S"]["C"] = character.class
	var rect = player_state["S"]["R"]
	rect = ServerData.GetCharacter(character.class).rect
	var weapon_type = gear.weapon.type
	if weapon_type == "Sword":
		rect.position.x = 0.0
	if weapon_type == "Bow":
		rect.position.x = 80.0
	if weapon_type == "Staff":
		rect.position.x = 160.0
	player_state["S"]["R"] = rect
	
	var color_params = {
		"helmetDarkOrigin" : RgbToColor(0, 0, 255.0),
		"helmetDarkNew" : RgbToColor(116.0, 109.0, 109.0),
		
		"helmetLightOrigin" : RgbToColor(0, 255.0, 255.0),
		"helmetLightNew" : RgbToColor(142.0, 143.0, 140.0),
		
		"helmetMediumOrigin" : RgbToColor(255.0, 0, 255.0),
		"helmetMediumNew" : RgbToColor(127.0, 127.0, 127.0),
		
		"bodyLightOrigin" : RgbToColor(255.0, 255.0, 255.0),
		"bodyLightNew" : RgbToColor(198.0, 198.0, 198.0),
		
		"bodyMediumOrigin" : RgbToColor(255.0, 255.0, 0),
		"bodyMediumNew" : RgbToColor(183.0, 180.0, 178.0),
		
		"bandOrigin" : RgbToColor(0, 0, 0),
		"bandNew" : RgbToColor(144.0, 81.0, 38.0),
		
		"weaponOrigin" : RgbToColor(255.0, 0, 0),
		"weaponNew" : RgbToColor(142.0, 143.0, 140.0),
		
		"weaponSecondaryOrigin" : RgbToColor(0, 255.0, 0),
		"weaponSecondaryNew" : RgbToColor(116.0, 64.0, 30.0),
	}
	var texture_params = {}
	color_params.merge(ServerData.GetCharacter(character.class).example_colors.params.colors, true)
	
	for slot in gear.keys():
		var item = gear[slot]
		var item_colors = item.colors
		var item_textures = item.textures
		
		for key in item_colors.keys():
			color_params[key] = item_colors[key]
		for key in item_textures.keys():
			texture_params[key] = item_textures[key]
	player_state["S"]["P"] = {
		"TextureParams" : texture_params,
		"ColorParams" : color_params,
	}
	return player_state

var used_names = {}
func CreateBot():
	randomize()
	var random = RandomNumberGenerator.new()
	random.randomize()
	var kits = [
		{
			"weapon" : 100,
			"class" : "Apprentice"
		},
		{
			"weapon" : random.randi_range(101,103),
			"armor" : random.randi_range(500,502),
			"class" : "Noble"
		},
		{
			"weapon" : random.randi_range(103,106),
			"helmet" : random.randi_range(403,404),
			"armor" : random.randi_range(503,504),
			"class" : "Paladin"
		},
		{
			"weapon" : random.randi_range(166,169),
			"helmet" : random.randi_range(467,470),
			"armor" : random.randi_range(567,570),
			"class" : "Nomad"
		},
		{
			"weapon" : random.randi_range(133,140),
			"armor" : random.randi_range(534,537),
			"class" : "Warlock"
		},
		{
			"weapon" : random.randi_range(133,140),
			"armor" : random.randi_range(534,537),
			"helmet" : random.randi_range(434,436),
			"class" : "Druid"
		},
	]
	var names = [
		"roggyrow",
		"Vicotious",
		"ADAMS",
		"Bearden",
		"Potlick",
		"johnson",
		"honor",
		"Luhrod"
	]
	var bot_name = names[0]
	for _bot_name in names:
		if used_names.has(bot_name):
			bot_name = _bot_name
		else:
			used_names[bot_name] = true
			break
	
	var kit = kits[randi() % len(kits)]
	var default_account_data = {
		"username" : bot_name,
		"character_slots": 1,
		"gold": 5000,
		"finished_tutorial": false,
		"time_tracker" : {},
		"achievements": {
		},
		"statistics": {
			"tiles_covered" : 0,
			"ability_used" : 0,
			"damage_taken" : 0,
			"bow_projectiles" : 0,
			"staff_projectiles" : 0,
			"sword_projectiles" : 0,
			"projectiles_landed" : 0,
			"deaths" : 0,
		},
		"home" : {
			"whitelist" : [],
			"open_mode" : "open",
			"objects" : [
				{
					"type" : "storage",
					"position" : Vector2(12*8,12*8),
					"loot" : [
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
					],
				}
			],
			"tiles" : [],
			"inventory" : {
				"objects" : {
					"storage" : 0,
					"apprentice_statue" : 1,
					"noble_statue" : 0,
					"nomad_statue" : 0,
					"scholar_statue" : 0,
				},
				"tiles" : {
					"grass" : 0,
					"stone" : 0,
					"stone_wall" : 0,
					"wooden_planks" : 20,
					"wooden_wall" : 10,
				},
			}
		},
		"classes": {
			"Apprentice": true,
			
			"Noble": false,
			"Nomad": false,
			"Scholar": false,
			
			"Knight": false,
			"Paladin": false,
			"Marauder": false,
			
			"Ranger": false,
			"Sentinel": false,
			"Scout": false,
			
			"Magician": false,
			"Druid": false,
			"Warlock": false,
		},
		"characters":[{
			"stats" : {
				"health" : 100,
				"attack" : 20,
				"defense" : 0,
				"speed" : 20,
				"dexterity" : 20,
				"vitality" : 20
			},
			"level" : 1,
			"exp" : 0,
			
			"ascension_stones" : 0,
			"used_ascension_stones" : 0,
			
			"stat_buffs" : {},
			"status_effects" : [],
			"ability_cooldown" : 0,
			
			"class" : "Apprentice",
			"statistics": {
				"tiles_covered" : 0,
				"damage_taken" : 0,
				"bow_projectiles" : 0,
				"staff_projectiles" : 0,
				"sword_projectiles" : 0,
				"projectiles_landed" : 0,
			},
			"gear" : {
				"weapon" : {
					"item" : 167,
					"id" : 123321231
				},
				"helmet" : null,
				"armor" : null
			},
			"inventory" : [
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
			]
		}],
		"graveyard":[],
	}
	var character = default_account_data.characters[0]
	for category in kit.keys():
		if character.has(category):
			character[category] = kit[category]
		elif character.gear.has(category):
			character.gear[category] = {
				"item" : kit[category],
				"id" : 123321231
			}
	return default_account_data
func HandleChat(username, classname, id):
	var server = get_node("/root/Server")
	var current_time = OS.get_system_time_msecs()
	
	if len(server.chat_messages) > 0:
		var last_chat = server.chat_messages[len(server.chat_messages)-1]
		randomize()
		if current_time-last_chat.timestamp >= (rand_range(4,5))*1000 and not last_chat.fake:
			var replies = [
				"Lets take back this kingdom!","Well that just happened...","Watch out, these guys leave a mark!", "Please tell me you have a spare sword...","The boss is right behind me, isn't it?", "Lets just say this could get awkward...", "Looks like we have company...", "Hey pal, Knock it off before you kick the bucket!"
			]
			
			server.chat_messages.append({
				"sender" : username,
				"timestamp" : OS.get_system_time_msecs(),
				"fake" : true,
			})
			server.rpc("RecieveChat", replies[randi() % len(replies)], username, classname, id)
