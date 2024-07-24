extends CanvasLayer

var achievement_button = preload("res://Scenes/SupportScenes/UI/Achievements/Achievement.tscn")

func _ready():
	$ExitButton.connect("pressed", self, "ToggleAchievements")
	$ExitButton/TouchScreenButton.connect("pressed", self, "ToggleAchievements")

func ToggleAchievements():
	get_parent().Toggle("achievements")

func Open():
	self.visible = true
	var account_data = GameUI.account_data
	var categories = ClientData.achievement_catagories
	var categories_node = $MarginContainer/Container/Categories
	
	for child in categories_node.get_children():
		if not child is HBoxContainer:
			categories_node.remove_child(child)
	for catagory in categories.keys():
		var category_instance = category_button.instance()
		category_instance.SetCategory(catagory)
		category_instance.name = catagory
		category_instance.connect("pressed", self, "SetCategory", [catagory])
		categories_node.add_child(category_instance)
		
	SetCategory("Classes")

func Close():
	self.visible = false

func SetCategory(category_name):
	var categories_node = $MarginContainer/Container/Categories
	var achievements_node = $MarginContainer/Container/ScrollContainer/AchievementsRoot
	var achievements = ClientData.achievement_catagories[category_name].achievements
	
	for child in categories_node.get_children():
		if not child is HBoxContainer:
			child.Disable()
	categories_node.get_node(category_name).Activate()
	
	for child in achievements_node.get_children():
		achievements_node.remove_child(child)
	for achievement in achievements:
		var achievement_instance = achievement_button.instance()
		achievement_instance.name = achievement
		achievement_instance.SetAchievement(achievement)
		
		if GameUI.account_data.achievements.has(achievement) and GameUI.account_data.achievements[achievement]:
			achievement_instance.Disable()
		else:
			achievement_instance.Activate()
		
		achievements_node.add_child(achievement_instance)

