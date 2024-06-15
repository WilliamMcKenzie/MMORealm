extends Node2D

onready var CharacterSpriteEle = $Character
onready var LevelEle = $LevelResizeContainer/Level
onready var PlayButton = $PlayResizer/Play

var character
var character_index

var characterPath = ["characters/characters_8x8.png", 13, 26, Vector2(0,0)]
var level = 1
var character_class = "Apprentice"

var weapon_colors = {}
var helmet_colors = {}
var armor_colors = {}

var weapon_textures = {}
var helmet_textures = {}
var armor_textures = {}

func AssignParameters(_character):
	var gear = _character.gear
	character = _character
	
	characterPath = CharacterData.GetCharacter(character.class).path
	level = character.level
	character_class = character.class
	
	if gear.has("weapon"):
		weapon_colors = ItemData.GetItem(character.gear.weapon.item).colors
		weapon_textures = ItemData.GetItem(character.gear.weapon.item).textures
	if gear.has("helmet"):
		helmet_colors = ItemData.GetItem(character.gear.helmet.item).colors
		helmet_textures = ItemData.GetItem(character.gear.helmet.item).textures
	if gear.has("armor"):
		armor_colors = ItemData.GetItem(character.gear.armor.item).colors
		armor_textures = ItemData.GetItem(character.gear.armor.item).textures

func _ready():
	LevelEle.text = character_class + " - Level " + str(level)
	CharacterSpriteEle.SetCharacterClass(character_class)
	if character.gear.has("weapon"):
		CharacterSpriteEle.SetCharacterWeapon(ItemData.GetItem(character.gear.weapon.item).type)
	
	SetSpriteData(CharacterSpriteEle, characterPath)
	SetSpriteColors(CharacterSpriteEle, weapon_colors, weapon_textures)
	SetSpriteColors(CharacterSpriteEle, helmet_colors, helmet_textures)
	SetSpriteColors(CharacterSpriteEle, armor_colors, armor_textures)
	
	PlayButton.connect("pressed", self, "EnterGame")
	
func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]
	
func SetSpriteColors(sprite, colors, textures):
	sprite.AddColorParams(colors, textures)

func EnterGame():
	get_parent().get_parent().EnterGame(character_index, character)
