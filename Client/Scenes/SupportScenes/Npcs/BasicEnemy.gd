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

onready var sprite_node = get_node("Control/Sprite")
var damage_indicator_scene = preload("res://Scenes/SupportScenes/UI/Indicators/DamageIndicator.tscn")
var effects = {}

func _ready():
	set_physics_process(false)

var is_active = false
var collision_connected = false

var finished_propogating = false
func Activate(_enemy_type):
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
	var chat_node = get_node("EnemyChatBubble")
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
	
	chat_node.position = Vector2(0,-_height*_scale)
	sprite_node.scale = Vector2(_scale,_scale)
	sprite_node.position = Vector2(rect_variable/2,rect_variable/2)
	hitbox_node.set_deferred("disabled", false)
	hitbox_node.shape = hitbox_node.shape.duplicate()
	hitbox_node.shape.extents = Vector2((_res/2)*_scale, (_height/2)*_scale)
	hitbox_node.position = Vector2(0,-(_height/2)*_scale)
	if enemy_data.has("custom_hitbox"):
		var hitbox = enemy_data.custom_hitbox
		hitbox_node.shape = hitbox_node.shape.duplicate()
		hitbox_node.shape.extents = Vector2(hitbox.x/2.0, hitbox.y/2.0)
		hitbox_node.position = Vector2(0,-(hitbox.y/2.0))
		if enemy_data.custom_hitbox == Vector2(0,0):
			hitbox_node.set_deferred("disabled", true)
	
	rect_size1 = Vector2(rect_variable,rect_variable-3)
	rect_size2 = Vector2(rect_variable,rect_variable)
	rect_position1 = Vector2(-rect_variable/2,-rect_variable+3)
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
	
	set_physics_process(true)
	SpeedModifiers()
	finished_propogating = true
	self.visible = true

func DeActivate():
	name = "Deactivated"
	$Area2D/Hitbox.set_deferred("disabled", true)
	is_active = false
	set_physics_process(false)
	self.visible = false
	finished_propogating = false

var clock_sync_timer = 0
var death_stance
func _physics_process(delta):
	clock_sync_timer += 1
	
	if clock_sync_timer % 10:
		if death_stance:
			$Area2D/Hitbox.disabled = true
		else:
			$Area2D/Hitbox.disabled = false
		
		if death_stance:
			$AnimationPlayer.play("Death")
		if not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("Idle")
	
	if clock_sync_timer == 40:
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

	if tile_index != TileMap.INVALID_CELL and ClientData.unique_tiles.has(tile_index) and not ClientData.GetEnemy(enemy_type).has("no_sink"):
		$Control.rect_size = rect_size1
		$Control.rect_position = rect_position1
	else:
		$Control.rect_size = rect_size2
		$Control.rect_position = rect_position2

var theoretical_position = position
var last_flip = 0
func MoveEnemy(new_position, flip = -1):
	theoretical_position = new_position
	if Server.IsWithinRange(new_position):
		self.visible = true
		var old_position = position
		set_position(theoretical_position)
		
		if flip != -1:
			sprite_node.flip_h = flip == 1
			return
		
		var can_flip = OS.get_system_time_msecs() - last_flip > 100 and not ("wing" in enemy_type)
		if can_flip and new_position.x-old_position.x > 0 and sprite_node.flip_h:
			last_flip = OS.get_system_time_msecs()
			sprite_node.flip_h = false
		elif can_flip and new_position.x-old_position.x < 0 and not sprite_node.flip_h:
			last_flip = OS.get_system_time_msecs()
			sprite_node.flip_h = true
	else:
		self.visible = false

func ShootProjectile():
	$AnimationPlayer.play("Attack")

#Damage Taken section
func DegreesToVector(degrees):
	var radians = deg2rad(degrees)
	var vector = Vector2(cos(radians), sin(radians))
	return vector

func ShowDamageIndicator(damage_amount):
	AudioManager.Play("hit", damage_amount/100)
	var total_damage = floor(-damage_amount - ClientData.GetEnemy(enemy_type).defense)
	if total_damage < damage_amount - damage_amount*0.9:
		total_damage = floor(damage_amount - damage_amount*0.9)
	if effects.has("invincible"):
		total_damage = 0
	
	var damage_indicator = damage_indicator_scene.instance()
	damage_indicator.get_node("Label").text = str(-total_damage)
	$IndicatorPlaceholder.add_child(damage_indicator)
	
	yield(get_tree().create_timer(1.0), "timeout")
	if is_instance_valid(damage_indicator):
		damage_indicator.queue_free()

func _on_Area2D_area_entered(body):
	var node = body.get_parent()
	if "damage" in node and node.original:
		Server.NPCHit(name,node.damage)
	if "damage" in node and node.damage:
		ShowDamageIndicator(-1*node.damage)
		if(not node.projectile_data.piercing):
			node.DeActivate()
