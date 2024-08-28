extends Node2D

export var enemy_type = "crab"
var distanceTraveled
var velocity = Vector2.ZERO

export var rect_size1 = Vector2(20,7)
export var rect_size2 = Vector2(20,10)

export var rect_position1 = Vector2(-10,-6)
export var rect_position2 = Vector2(-10,-9)

var damage_indicator_scene = preload("res://Scenes/SupportScenes/UI/Indicators/DamageIndicator.tscn")
var projectile_dict = {}
var effects = {}
var effects_node = preload("res://Scenes/SupportScenes/PlayerCharacter/Effects.tscn")

func _ready():
	$Area2D.connect("area_entered", self, "OnHit")
	if not has_node("ZContainer"):
		add_child(effects_node.instance())

var clock_sync_timer = 0
func _physics_process(delta):
	clock_sync_timer += 1
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("Idle")
	SpeedModifiers()
	if clock_sync_timer == 20:
		clock_sync_timer = 0
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
	else:
		if self.visible:
				self.visible = false

func DeathStance():
	$AnimationPlayer.play("Death")

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
	
	var sprite = get_node("Sprite")
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
	if is_instance_valid(get_node("DamageIndicator")): 
		get_node("DamageIndicator").queue_free()
