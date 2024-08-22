extends KinematicBody2D

onready var animationTree = $AnimationTree
onready var CharacterSpriteEle = $Control/CharacterSprite
var projectile_dict = {}
var last_status_effects = []
var last_sprite_data = {
	"P" : {
		"ColorParams" : {}
	}
}

func _physics_process(delta):
	SpeedModifiers()
	if projectile_dict.size() > 0:
		ShootProjectile()

func SpeedModifiers():
	var tilemap = get_parent().get_parent().get_parent().get_node("TileMap")
	var tile_coords = tilemap.world_to_map(position)
	var tile_index = tilemap.get_cell(tile_coords.x, tile_coords.y)

	if tile_index != TileMap.INVALID_CELL and ClientData.unique_tiles.has(tile_index):
		$Control.rect_size = Vector2(20,7)
		$Control.rect_position = Vector2(-10,-6)
	else:
		$Control.rect_size = Vector2(20,10)
		$Control.rect_position = Vector2(-10,-9)

func SetCharacterSprite(sprite_data):
	var check1 = sprite_data.duplicate(true)
	check1.erase("P")
	var answer1 = last_sprite_data.duplicate(true)
	answer1.erase("P")
	var check2 = sprite_data["P"]["ColorParams"]
	var answer2 = last_sprite_data["P"]["ColorParams"]
	
	if UtilityFunctions.CompareDictionaries(check1, answer1) and UtilityFunctions.CompareDictionaries(check2, answer2):
		return
	else:
		last_sprite_data = sprite_data
		
	var character_class = sprite_data["C"]
	var region_rect = sprite_data["R"]
	var params = sprite_data["P"]
	
	CharacterSpriteEle.SetCharacterClass(character_class)
	CharacterSpriteEle.SetParams(params)
	SetSpriteData(CharacterSpriteEle, ClientData.GetCharacter(character_class).path)
	CharacterSpriteEle.region_rect = region_rect

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]

func UpdateStatusEffects(status_effects):
	last_status_effects = status_effects
	for status_node in $ZContainer/HBoxContainer/HBoxContainer.get_children():
		if status_effects.has(status_node.name):
			status_node.visible = true
		else:
			status_node.visible = false

func MovePlayer(new_position, animation, sprite_data):
	set_position(new_position)
	SetCharacterSprite(sprite_data)
	
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
			for projectile_data in projectile_dict[projectile_time]:
				var projectile_path = "res://Scenes/SupportScenes/Projectiles/Players/Projectile.tscn"
				var projectile = load(projectile_path)
				var projectile_instance = projectile.instance()
				
				#Set projectile data
				projectile_instance.position = $Axis.global_position + projectile_data["Direction"]*3
				projectile_instance.original = false
				projectile_instance.damage = round(CalculateDamageWithMultiplier(projectile_data["Damage"]))
				projectile_instance.set_direction(projectile_data["Direction"])
				projectile_instance.projectile = projectile_data["Projectile"]
				projectile_instance.tile_range = projectile_data["TileRange"]
				projectile_instance.piercing = projectile_data["Piercing"]
				projectile_instance.formula = projectile_data["Formula"]
				projectile_instance.speed = projectile_data["Speed"]
				projectile_instance.size = projectile_data["Size"]
				
				projectile_dict.erase(projectile_time)
				get_parent().get_parent().add_child(projectile_instance)
				get_parent().get_parent().get_node(projectile_instance.name).look_at(projectile_data["MousePosition"])

func CalculateDamageWithMultiplier(damage):
	if last_status_effects.has("damaging"):
		damage = floor(damage*1.25)
		
	return damage
