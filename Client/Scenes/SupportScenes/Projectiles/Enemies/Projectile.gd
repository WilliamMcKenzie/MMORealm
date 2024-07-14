extends Sprite

var projectile_data

var is_active = false
var velocity = Vector2.ZERO
var time = 0
onready var expression = Expression.new()

func _physics_process(delta):
	if is_active:
		time += delta
		self.visible = true
		if projectile_data.start_position.distance_to(projectile_data.path) >= projectile_data.tile_range*8:
			is_active = false
			self.visible = false
			return
	
		expression.parse(projectile_data.formula,["x"])
		
		var alive_time = OS.get_system_time_msecs()/1000.0 - projectile_data.start_time
		var vertical_move_vector = projectile_data.speed * projectile_data.direction.normalized() * delta
		var horizontal_move_vector = Vector2(-velocity.y, velocity.x) * expression.execute([time * 50]) * 0.05
		
		projectile_data.path += vertical_move_vector
		look_at(position+projectile_data.path + horizontal_move_vector)
		position = projectile_data.path + horizontal_move_vector
	
func Activate():
	self.visible = true
	self.position = projectile_data.position
	self.velocity = projectile_data.direction.normalized()*projectile_data.speed
	projectile_data.start_position = self.position
	time = 0
	look_at(projectile_data.direction+position)
	
