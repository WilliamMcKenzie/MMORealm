extends TouchScreenButton

func _ready():
	connect("pressed", self, "UseAbility")

func _physics_process(delta):
	if GameUI.last_character and GameUI.last_character.gear.helmet == null:
		self.self_modulate = Color(113.0/255,113.0/255,113.0/255)
	elif GameUI.last_character and GameUI.last_character.ability_cooldown > 0 :
		GameUI.last_character.ability_cooldown -= delta
		self.self_modulate = Color(113.0/255,113.0/255,113.0/255)
		$Timer.text = str(floor(GameUI.last_character.ability_cooldown))
		$Timer.visible = true
	else:
		self.self_modulate = Color(1,1,1)
		$Timer.visible = false
	
	if(Input.is_action_pressed("ability")) and not GameUI.in_chat:
		UseAbility()

func UseAbility():
	if GameUI.last_character and GameUI.last_character.ability_cooldown <= 0:
		Server.UseAbility()
