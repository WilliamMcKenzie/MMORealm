extends Node2D

var distanceTraveled
var velocity = Vector2.ZERO

var enemy_type = "crab"
var rect_size1 = Vector2(20,7)
var rect_size2 = Vector2(20,10)
var rect_position1 = Vector2(-10,-6)
var rect_position2 = Vector2(-10,-9)

var texture_8x8 = preload("res://Assets/npcs/enemies_8x8.png")
var texture_16x16 = preload("res://Assets/npcs/enemies_16x16.png")
var texture_32x32 = preload("res://Assets/npcs/enemies_32x32.png")

var damage_indicator_scene = preload("res://Scenes/SupportScenes/UI/Indicators/DamageIndicator.tscn")
var effects = {}

func _ready():
	set_physics_process(false)

var is_active = false

func Activate(_enemy_type):
	
	$Area2D.connect("area_entered", self, "OnHit")
	set_physics_process(true)
	self.visible = true
	is_active = true
	
	enemy_type = _enemy_type
	var enemy_data = ClientData.GetEnemy(enemy_type)
	var _animations = enemy_data.animations
	var _height = enemy_data.height
	var _scale = enemy_data.scale
	var _rect = enemy_data.rect
	var _res = enemy_data.res
	var _texture
	
	#Nodes
	var sprite_node = get_node("Control/Sprite")
	var indicator_node = get_node("IndicatorPlaceholder")
	var effects_node = get_node("ZContainer")
	var hitbox_node = get_node("Area2D/Hitbox")
	var rect_variable = (_res*_scale)
	
	if _res == 10:
		_texture = texture_8x8
	if _res == 18:
		_texture = texture_16x16
	if _res == 38:
		_texture = texture_32x32
	
	sprite_node.scale = Vector2(_scale,_scale)
	sprite_node.position = Vector2(rect_variable/2,rect_variable/2)
	hitbox_node.shape = hitbox_node.shape.duplicate()
	hitbox_node.shape.extents = Vector2((_res/2)*_scale, (_height/2)*_scale)
	hitbox_node.position = Vector2(0,-(_height/2)*_scale)
	
	rect_size1 = Vector2(rect_variable,rect_variable)
	rect_size2 = Vector2(rect_variable,rect_variable)
	rect_position1 = Vector2(-rect_variable/2,-rect_variable)
	rect_position2 = Vector2(-rect_variable/2,-rect_variable)
	
	indicator_node.position = Vector2(0,-_height*_scale)
	effects_node.position = Vector2(0,-(_height*_scale)+8)
	
	sprite_node.texture = _texture
	sprite_node.region_rect = _rect
	sprite_node.hframes = _rect.size.x/_rect.size.y
	sprite_node.vframes = 1
	
	var animation_node = get_node("AnimationPlayer")
	for animation_name in animation_node.get_animation_list():
		var original_animation = animation_node.get_animation(animation_name)
		var duplicated_animation = original_animation.duplicate(true)
		animation_node.add_animation(animation_name, duplicated_animation)
	for animation_name in _animations.keys():
		var frame_time = 0
		var animation = animation_node.get_animation(animation_name)
		var key_count = animation.track_get_key_count(0)
		
		for i in range(key_count - 1, -1, -1):
			animation.track_remove_key(0, i)
		
		animation.length = 0.3*len(_animations[animation_name])
		for frame in _animations[animation_name]:
			animation.track_insert_key(0, frame_time, frame)
			frame_time += 0.3

func DeActivate():
	$Area2D.disconnect("area_entered", self, "OnHit")
	set_physics_process(false)
	hide()
	is_active = false

var clock_sync_timer = 0
var death_stance
func _physics_process(delta):
	clock_sync_timer += 1
	if not $AnimationPlayer.is_playing() and death_stance:
		$AnimationPlayer.play("Death")
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("Idle")
		
	if clock_sync_timer == 20:
		clock_sync_timer = 0
		SpeedModifiers()
		UpdateStatusEffects(effects)

func UpdateStatusEffects(status_effects):
	for status_node in $ZContainer/HBoxContainer/HBoxContainer.get_children():
		if status_effects.has(status_node.name):
			status_node.visible = true
			$ZContainer.visible = true
		else:
			status_node.visible = false
	if status_effects.size() == 0:
		$ZContainer.visible = false

func SpeedModifiers():
	var tilemap = get_parent().get_parent().get_parent().get_node("TileMap")
	var tile_coords = tilemap.world_to_map(position)
	var tile_index = tilemap.get_cell(tile_coords.x, tile_coords.y)

	if tile_index != TileMap.INVALID_CELL and ClientData.unique_tiles.has(tile_index):
		$Control.rect_size = rect_size1
		$Control.rect_position = rect_position1
	else:
		$Control.rect_size = rect_size2
		$Control.rect_position = rect_position2

var theoretical_position = position
func MoveEnemy(new_position):
	theoretical_position = new_position
	if Server.IsWithinRange(new_position):
		if not self.visible:
				self.visible = true
		var old_position = position
		set_position(theoretical_position)
		
		if new_position.x-old_position.x > 0 and $Control/Sprite.flip_h:
			$Control/Sprite.flip_h = false
		elif new_position.x-old_position.x < 0 and not $Control/Sprite.flip_h:
			$Control/Sprite.flip_h = true
	elif self.visible:
		self.visible = false

func ShootProjectile():
	$AnimationPlayer.play("Attack")

#Damage Taken section
func OnHit(body):
	if "damage" in body.get_parent() and body.get_parent().original == true:
		Server.NPCHit(name,body.get_parent().damage)
	if "damage" in body.get_parent():
		ShowDamageIndicator(-1*body.get_parent().damage)
		body.get_parent().interaction(self)

func ShowDamageIndicator(damage_amount):
	var total_damage = floor(-damage_amount - ClientData.GetEnemy(enemy_type).defense)
	if total_damage < damage_amount - damage_amount*0.9:
		total_damage = floor(damage_amount - damage_amount*0.9)
	if effects.has("invincible"):
		total_damage = 0
	
	var shape = get_node("Area2D/Hitbox").shape as RectangleShape2D
	var _x = shape.extents.x
	
	var damage_indicator = damage_indicator_scene.instance()
	damage_indicator.get_node("Label").text = str(-total_damage)
	$IndicatorPlaceholder.add_child(damage_indicator)

	var timer = Timer.new()
	timer.wait_time = 1.0 # Adjust this as needed
	timer.one_shot = true
	add_child(timer)
	timer.start()

	timer.connect("timeout", self, "DamageIndicatorTimeout")

func DamageIndicatorTimeout():
	if has_node("DamageIndicator"): 
		get_node("DamageIndicator").queue_free()
