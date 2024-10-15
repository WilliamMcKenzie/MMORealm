extends Sprite

var projectile_data

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

var clock_sync_timer = 0
func _physics_process(delta):
	clock_sync_timer += 1
	if clock_sync_timer >= 1:
		clock_sync_timer = 0
		time += delta
		last_active_time += delta
		
		if Server.IsWithinRange(theoretical_position):
			if not self.visible:
				self.visible = true
			
			if spin:
				rotation_degrees += 5
			
			time += delta
			var expression = Expression.new()
			var formula = projectile_data.formula
			if not default_expressions.has(formula):
				expression.parse(formula,["x"])
				default_expressions[formula] = expression
			else:
				expression = default_expressions[formula]
			
			var alive_time = Server.client_clock/1000.0 - projectile_data.start_time
			var vertical_move_vector = projectile_data.speed * projectile_data.direction.normalized() * last_active_time
			var horizontal_move_vector = Vector2(-velocity.y, velocity.x) * expression.execute([time * 10]) * 0.05
			
			projectile_data.path += vertical_move_vector
			position = projectile_data.path + horizontal_move_vector
			last_active_time = 0
			
		elif self.visible:
			self.visible = false

func Activate():
	set_physics_process(true)
	self.visible = true
	self.position = projectile_data.position
	self.velocity = projectile_data.direction.normalized()*projectile_data.speed
	
	projectile_data.start_position = self.position
	theoretical_position = projectile_data.position
	time = 0
	last_active_time = 0
	delta_counter = 0
	
	look_at(projectile_data.direction+projectile_data.position)
	texture = texture.duplicate()
	texture.region = ClientData.GetProjectile(projectile_data.name).rect
	rotation_degrees += ClientData.GetProjectile(projectile_data.name).rotation
	spin = ClientData.GetProjectile(projectile_data.name).spin
	if ClientData.GetProjectile(projectile_data.name).has("scale"):
		var _scale = ClientData.GetProjectile(projectile_data.name).scale
		scale = Vector2(_scale,_scale)
	else:
		scale = Vector2(1,1)

func DeActivate():
	set_physics_process(false)
	hide()
	is_active = false
