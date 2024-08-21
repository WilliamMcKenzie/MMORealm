extends CanvasLayer

var reputation_per_tick = 0
var reputation_end = 65
var reputation = 0
onready var reputation_node = $Container/ReputationContainer/Reputation/Label

var leaderboards_map = {
	"weekly" : Vector2(0, 230),
	"monthly" : Vector2(10, 230),
	"all_time" : Vector2(20, 230),
}
var leaderboards = {
	"weekly" : [],
	"monthly" : [],
	"all_time" : [],
}

func _ready():
	$Container/HomeButton.connect("pressed", self, "GoHome")

func _physics_process(delta):
	if visible == false or reputation == reputation_end:
		return
		
	if reputation < reputation_end:
		reputation += reputation_per_tick
	if reputation > reputation_end:
		$Container/HomeButton.modulate = Color(1,1,1,1)
		reputation = reputation_end
	
	var leaderboard_position = CalculateRanking(reputation)
	if leaderboard_position.which:
		$Container/ReputationContainer/Placement.visible = true
		$Container/ReputationContainer/Placement/TextureRect.texture.region = Rect2(leaderboards_map[leaderboard_position.which], Vector2(10,10))
		$Container/ReputationContainer/Placement/Label.text = "#"+str(leaderboard_position.position)
	else:
		$Container/ReputationContainer/Placement.visible = false
	
	reputation_node.text = str(round(reputation))

func CalculateRanking(reputation):
	var weekly = leaderboards.weekly
	var monthly = leaderboards.monthly
	var all_time = leaderboards.all_time
	var leaderboard_catagories = ["all_time","monthly","weekly"]
	
	var which
	var position
	
	for catagory in leaderboard_catagories:
		var leaderboard = leaderboards[catagory]
		if reputation > leaderboard[len(leaderboard)-1].reputation:
			position = leaderboard.size()+1
			which = catagory
			for character in leaderboard:
				if reputation > character.reputation:
					position -= 1
			return {"which" : which,"position" : position,}
	return {"which" : which,"position" : position,}

func GoHome():
	GameUI.Toggle("death")
	GameUI.GoHome()

func Open():
	$Container/HomeButton.modulate = Color(1,1,1,0)
	$Container/Label.text = GameUI.account_data.username
	leaderboards = GameUI.GetLeaderboard()
	
	var character_data = GameUI.last_character
	var gear = {}
	
	for slot in character_data.gear.keys():
		if character_data.gear[slot]:
			gear[slot] = ClientData.GetItem(character_data.gear[slot].item)
	SetCharacterSprite(GameUI.last_character, gear)
	
	reputation_end = character_data.level
	reputation_per_tick = reputation_end/120.0
	
	self.visible = true

func Close():
	self.visible = false
	
func SetCharacterSprite(character, gear):
	var CharacterSpriteEle = $Container/CharacterContainer/Character
	CharacterSpriteEle.material = CharacterSpriteEle.material.duplicate()
	CharacterSpriteEle.SetCharacterClass(character.class)
	SetSpriteData(CharacterSpriteEle, ClientData.GetCharacter(character.class).path)
	CharacterSpriteEle.ColorGear(gear, character.class)
	if gear.has("weapon"):
		CharacterSpriteEle.SetCharacterWeapon(gear["weapon"].type)

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]

