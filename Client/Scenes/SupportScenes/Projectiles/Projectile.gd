extends Sprite

var type = "enemy"
var original
var projectile_data
var damage

var is_active = false
var velocity = Vector2.ZERO
var time = 0
var last_active_time = 0
var theoretical_position = Vector2.ZERO
var spin = false

var default_expressions = {}
var delta_counter = 0
func _ready():
	set_physics_process(false)
	if "Player" in get_parent().name:
		type = "player"

var clock_sync_timer = 0
func _physics_process(delta):
	clock_sync_timer += 1
	if clock_sync_timer >= 1:
		clock_sync_timer = 0
		time += delta
		last_active_time += delta
		if Server.IsWithinRange(position):
			self.visible = true
			if spin:
				rotation_degrees += 5
		else:
			self.visible = false
		
		time += delta
		var expression = Expression.new()
		var formula = projectile_data.formula
		if not default_expressions.has(formula):
			expression.parse(formula,["x"])
			default_expressions[formula] = expression
		else:
			expression = default_expressions[formula]
		
		var vertical_move_vector = projectile_data.speed * projectile_data.direction.normalized() * last_active_time
		var horizontal_move_vector = Vector2(-velocity.y, velocity.x) * expression.execute([time * 10]) * 0.05
		
		projectile_data.path += vertical_move_vector
		position = projectile_data.path + horizontal_move_vector
		last_active_time = 0
	
	if (position - projectile_data.start_position).length()/8 >= projectile_data.tile_range:
		DeActivate()

func Activate():
	is_active = true
	var projectile_info = ClientData.GetProjectile(projectile_data.name)
	
	set_physics_process(true)
	self.visible = true
	self.position = projectile_data.start_position
	self.velocity = projectile_data.direction.normalized()*projectile_data.speed
	projectile_data.start_position = self.position
	time = 0
	last_active_time = 0
	delta_counter = 0
	
	look_at(projectile_data.direction+projectile_data.start_position)
	frame_coords = projectile_info.rect.position/10
	rotation_degrees += projectile_info.rotation
	spin = projectile_info.spin
	if projectile_info.has("scale"):
		var _scale = projectile_info.scale
		scale = Vector2(_scale,_scale)
	else:
		scale = Vector2(1,1)
	if type == "player":
		$Area2D/Hitbox.set_deferred("disabled", true)
		yield(get_tree().create_timer(0.05), "timeout")
		$Area2D/Hitbox.set_deferred("disabled", false)
		$Area2D/Hitbox.shape.radius = projectile_data.size

func DeActivate():
	if type == "player":
		$Area2D/Hitbox.set_deferred("disabled", true)
	set_physics_process(false)
	hide()
	is_active = false

func _on_Area2D_body_entered(body):
	if body.name == "TileMap" or "object_id" in body.get_parent():
		DeActivate()
