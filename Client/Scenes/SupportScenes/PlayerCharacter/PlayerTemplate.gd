extends KinematicBody2D

onready var animationTree = $AnimationTree
onready var CharacterSprite = $CharacterSprite
var projectile_dict = {}
var last_sprite_data

func _physics_process(delta):
	if projectile_dict != {}:
		ShootProjectile()

func SetCharacterSprite(sprite_data):
	if last_sprite_data == sprite_data:
		return
	last_sprite_data = sprite_data
		
	var character_class = sprite_data["C"]
	var region_rect = sprite_data["R"]
	var params = sprite_data["P"]
	
	CharacterSprite.SetCharacterClass(character_class)
	CharacterSprite.SetParams(params)
	SetSpriteData(CharacterSprite, ClientData.GetCharacter(character_class).path)
	CharacterSprite.region_rect = region_rect

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]

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
			var projectile_data = projectile_dict[projectile_time]
			var projectile_path = "res://Scenes/SupportScenes/Projectiles/Players/" + str(projectile_data["Projectile"]) + ".tscn"
			var projectile = load(projectile_path)
			var projectile_instance = projectile.instance()
			projectile_instance.position = $Axis.global_position
			
			#Set projectile data
			projectile_instance.damage = projectile_data["Damage"]
			projectile_instance.tile_range = projectile_data["TileRange"]
			projectile_instance.set_direction(projectile_data["Direction"])
			projectile_dict.erase(projectile_time)
			get_parent().get_parent().add_child(projectile_instance)
			get_parent().get_parent().get_node(projectile_instance.name).look_at(projectile_data["MousePosition"])
