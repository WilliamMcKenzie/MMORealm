extends Sprite

var projectile_data

var is_active = false
var velocity = Vector2.ZERO
var time = 0
var theoretical_position = 0
onready var expression = Expression.new()

var delta_counter = 0
func _physics_process(delta):
	if is_active:
		time += delta
		expression.parse(projectile_data.formula,["x"])
		
		var alive_time = Server.client_clock/1000.0 - projectile_data.start_time
		var vertical_move_vector = projectile_data.speed * projectile_data.direction.normalized() * delta
		var horizontal_move_vector = Vector2(-velocity.y, velocity.x) * expression.execute([time * 50]) * 0.05
		
		projectile_data.path += vertical_move_vector
		theoretical_position = projectile_data.path + horizontal_move_vector
		
		if Server.IsWithinRange(theoretical_position):
			if not self.visible:
				self.visible = true
			position = theoretical_position
		elif self.visible:
			self.visible = false

#Rotating the sprite an extra 90deg to make it look correct
func Activate():
	self.visible = true
	self.position = projectile_data.position
	self.velocity = projectile_data.direction.normalized()*projectile_data.speed
	projectile_data.start_position = self.position
	theoretical_position = self.position
	time = 0
	delta_counter = 0
	look_at(projectile_data.direction+projectile_data.position)
	rotation_degrees += 90

func DeActivate():
	is_active = false
	self.visible = false
