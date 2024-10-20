extends CanvasLayer

var saved_settings = {}
var settings = [
	{
		"title" : "Max FPS",
		"description" : "Lower max fps provides more constistency.",
		"data" : {
			"type" : "input",
			"default" : 60,
		}
	},
	{
		"title" : "Camera Zoom",
		"description" : "How far you can see.",
		"data" : {
			"type" : "input",
			"default" : 1,
		}
	},
	{
		"title" : "Show FPS",
		"description" : "Have your FPS show up on the screen.",
		"data" : {
			"type" : "checkbox",
			"default" : false,
		}
	},
	{
		"title" : "Show Ping",
		"description" : "Have your ping show up on the screen.",
		"data" : {
			"type" : "checkbox",
			"default" : false,
		}
	},
	{
		"title" : "VSync",
		"description" : "VSync can reduce screen tearing, may lower performance.",
		"data" : {
			"type" : "checkbox",
			"default" : true,
		}
	},
	{
		"title" : "Hide Players",
		"description" : "Hiding other players can improve performance.",
		"data" : {
			"type" : "checkbox",
			"default" : false,
		}
	},
	{
		"title" : "Hide Player Shots",
		"description" : "Hiding other players shots can improve performance.",
		"data" : {
			"type" : "checkbox",
			"default" : false,
		}
	},
	{
		"title" : "Auto Open Chests",
		"description" : "Automatically open any loot you walk over.",
		"data" : {
			"type" : "checkbox",
			"default" : false,
		}
	},
	{
		"title" : "Open Inventory",
		"description" : "Keybind to open your inventory.",
		"data" : {
			"type" : "keybind",
			"default" : OS.find_scancode_from_string("B"),
		}
	},
	{
		"title" : "Interact",
		"description" : "Keybind to enter dungeons and talk to npcs.",
		"data" : {
			"type" : "keybind",
			"default" : OS.find_scancode_from_string("I"),
		}
	},
	{
		"title" : "Use Ability",
		"description" : "Keybind to activate your helmet ability.",
		"data" : {
			"type" : "keybind",
			"default" : OS.find_scancode_from_string("SPACE"),
		}
	},
	{
		"title" : "Return To Port",
		"description" : "Keybind to escape danger.",
		"data" : {
			"type" : "keybind",
			"default" :  OS.find_scancode_from_string("R"),
		}
	},
]
var setting_scenes = {
	"checkbox" : preload("res://Scenes/SupportScenes/UI/Settings/SettingScenes/CheckboxSetting.tscn"),
	"input" : preload("res://Scenes/SupportScenes/UI/Settings/SettingScenes/InputSetting.tscn"),
	"slider" : preload("res://Scenes/SupportScenes/UI/Settings/SettingScenes/SliderSetting.tscn"),
	"keybind" : preload("res://Scenes/SupportScenes/UI/Settings/SettingScenes/KeybindSetting.tscn")
}

func _ready():
	$MarginContainer/Container/Categories/Home.connect("pressed", self, "GoHome")
	$ExitButton.connect("pressed", self, "Toggle")
	
	saved_settings = ClientAuth.LoadSettings()
	for setting in settings:
		var exists = saved_settings.has(setting.title)
		if exists:
			setting.data.default = saved_settings[setting.title]
		
		var scene = setting_scenes[setting.data.type].instance()
		scene.SetSettings(setting.title, setting.description, setting.data.default)
		$MarginContainer/Container/ScrollContainer/SettingsRoot.add_child(scene)
	
	for setting in saved_settings.keys():
		ChangeValue(setting, saved_settings[setting])

func ChangeValue(which, value):
	saved_settings[which] = value
	ClientAuth.SaveSettings(saved_settings)
	
	if which == settings[0].title:
		Engine.target_fps = max(value, 10)
	if which == settings[1].title:
		Settings.zoom = max(value, 0.7)
	if which == settings[2].title:
		Settings.show_fps = value
	if which == settings[3].title:
		Settings.show_ping = value
	if which == settings[4].title:
		OS.vsync_enabled = value
	if which == settings[5].title:
		Settings.hide_players = value
	if which == settings[6].title:
		Settings.hide_player_shots = value
	if which == settings[7].title:
		Settings.auto_open_chests = value
	if which == settings[8].title:
		var event = InputEventKey.new()
		event.scancode = value
		
		InputMap.action_erase_events("open_inventory")
		InputMap.action_add_event("open_inventory", event)
	if which == settings[9].title:
		var event = InputEventKey.new()
		event.scancode = value
		
		InputMap.action_erase_events("interact")
		InputMap.action_add_event("interact", event)
	if which == settings[10].title:
		var event = InputEventKey.new()
		event.scancode = value
		
		InputMap.action_erase_events("ability")
		InputMap.action_add_event("ability", event)
	if which == settings[11].title:
		var event = InputEventKey.new()
		event.scancode = value
		
		InputMap.action_erase_events("nexus")
		InputMap.action_add_event("nexus", event)

func GoHome():
	GameUI.GoHome()

func Toggle():
	GameUI.Toggle("settings")

func Open():
	self.visible = true

func Close():
	self.visible = false
