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
		
		var alive_time = OS.get_system_time_msecs()/1000.0 - projectile_data.start_time
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
		
		#Check if colliding
		var space_state = get_world_2d().direct_space_state
		var result = true
		var spots_to_check = [Vector2(0,0)]
		for spot in spots_to_check:
<<<<<<< Updated upstream
			var check = space_state.intersect_point(position+spot, 1, [], 4, true, true)
			if check.size() > 0:
				for i in check:
					if not "is_projectile" in i["collider"]:
						result = false
						print("no is_projectile found in "+ i["collider"].name)
						break
=======
			var collision1 = space_state.intersect_point(position+spot, 1, [], 1, true, true)
			var collision17 = space_state.intersect_point(position+spot, 17, [], 17, true, true)
			var colliding = collision1.size() > 0 or collision17.size() > 0
			if colliding:
				var enviornment = collision1[0].collider.name == "TileMap"
				var player = collision1[0].collider.name == "Axis"
				var other_player = collision17[0].collider.name == "PlayerTemplate"
				
				if enviornment:
					result = false
				if (other_player or player) and not projectile_data.piercing:
					result = false
>>>>>>> Stashed changes
		
		#Check if done
		if not result or projectile_data.start_position.distance_to(projectile_data.path) >= projectile_data.tile_range*8:
			is_active = false
			self.visible = false
			return

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
