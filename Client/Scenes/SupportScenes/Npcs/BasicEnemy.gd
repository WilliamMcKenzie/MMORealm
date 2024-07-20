extends Node2D

export var enemy_type = "crab"
var distanceTraveled
var velocity = Vector2.ZERO

var damage_indicator_scene = preload("res://Scenes/SupportScenes/UI/Indicators/DamageIndicator.tscn")
var projectile_dict = {}

func _physics_process(delta):
	if not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("Idle")

func _ready():
	$Area2D.connect("area_entered", self, "OnHit")

var theoretical_position = position
func MoveEnemy(new_position):
	theoretical_position = new_position
	if Server.IsWithinRange(new_position):
		self.visible = true
		var old_position = position
		set_position(theoretical_position)
		
		if new_position.x-old_position.x > 0:
			$Sprite.flip_h = false
		elif new_position.x-old_position.x < 0:
			$Sprite.flip_h = true
	else:
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
