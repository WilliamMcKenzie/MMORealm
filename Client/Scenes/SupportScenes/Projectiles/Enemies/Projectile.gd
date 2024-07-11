extends Sprite

var projectile_data

var is_active = false
var velocity = Vector2.ZERO
onready var expression = Expression.new()

func _physics_process(delta):
	if is_active:
		self.visible = true
		if OS.get_system_time_msecs()/1000 - projectile_data.start_time > projectile_data.lifespan:
			is_active = false
			self.visible = false
			return
	
		var initial_offset = velocity * delta
		var time = OS.get_system_time_msecs()/1000 - projectile_data.start_time
		
		expression.parse(projectile_data.formula,["x"])
		projectile_data.path += initial_offset
		var pattern_offset = Vector2(velocity.x, -velocity.y) * expression.execute([time * 50]) * 0.05
		position = projectile_data.path + pattern_offset
	
func Activate():
	self.visible = true
	self.position = projectile_data.position
	self.velocity = projectile_data.direction.normalized()*projectile_data.speed
	
	look_at(projectile_data.direction+position)
	
	print(projectile_data.direction)
	
