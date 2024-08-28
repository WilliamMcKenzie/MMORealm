extends Node

var current_class = "Apprentice"

#Tile data
var unique_tiles = {
	0 : 0.01,
	1 : 0.5,
}

var basic_loot_pools = {
	"none" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"lowlands_1" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"lowlands_2" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"midlands_1" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"midlands_2" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"highlands_1" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"highlands_2" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"godlands_1" : {
		"soulbound_loot" : [
			{
				"item" : 0,
				"chance" : 0.05,
				"threshold" : 0.5,
			},
		],
		"loot" : []
	},
	"ruler_1" : {
		"soulbound_loot" : [
			{
				"item" : 0,
				"chance" : 0.3,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"encounter_1" : {
		"soulbound_loot" : [
			{
				"item" : 0,
				"chance" : 0.5,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"encounter_2" : {
		"soulbound_loot" : [
			{
				"item" : 0,
				"chance" : 1,
				"threshold" : 0.1,
			},
		],
		"loot" : []
	},
}
var special_loot_pools = {
	"oranix" : {
		"override" : "ruler_1",
		"soulbound_loot" : [
			{
				"item" : 105,
				"chance" : 0.003,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"vigil_guardian" : {
		"override" : "encounter_1",
		"soulbound_loot" : [
			{
				"item" : 105,
				"chance" : 0.003,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"atlas" : {
		"override" : "encounter_2",
		"soulbound_loot" : [
			{
				"item" : 105,
				"chance" : 0.003,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
}

func _ready():
	var high_chance = 0.15
	var decent_chance = 0.1
	var low_chance = 0.05
	var rare_chance = 0.01
	
	for item_id in items.keys():
		var item = items[item_id]
		if item.tier == "0":
			basic_loot_pools["lowlands_1"].loot.append({
				"item" : item_id,
				"chance" : low_chance,
			})
			basic_loot_pools["lowlands_2"].loot.append({
				"item" : item_id,
				"chance" : high_chance,
			})
		if item.tier == "1":
			basic_loot_pools["midlands_1"].loot.append({
				"item" : item_id,
				"chance" : low_chance,
			})
			basic_loot_pools["midlands_2"].loot.append({
				"item" : item_id,
				"chance" : high_chance,
			})
			basic_loot_pools["highlands_1"].loot.append({
				"item" : item_id,
				"chance" : low_chance,
			})
			basic_loot_pools["highlands_2"].loot.append({
				"item" : item_id,
				"chance" : high_chance,
			})
		if item.tier == "2":
			basic_loot_pools["highlands_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : rare_chance,
				"threshold" : 0.2,
			})
			basic_loot_pools["highlands_2"].soulbound_loot.append({
				"item" : item_id,
				"chance" : decent_chance,
				"threshold" : 0.2,
			})
			basic_loot_pools["godlands_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : decent_chance,
				"threshold" : 0.2,
			})
		if item.tier == "3":
			basic_loot_pools["godlands_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : 0.01,
				"threshold" : 0.5,
			})
			basic_loot_pools["ruler_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : 0.05,
				"threshold" : 0.05,
			})
	
	for enemy_name in special_loot_pools.keys():
		var pool = special_loot_pools[enemy_name]
		pool.soulbound_loot += basic_loot_pools[pool.override].soulbound_loot
		pool.loot += basic_loot_pools[pool.override].loot

var rulers = {
	"oranix" : {
		"health" : 20000,
		"defense" : 10,
		"exp" : 2000,
		"behavior" : 0,
		"speed" : 10,
		"dungeon" : {
			"rate" : 0,
			"name" : "orc_vigil"
		},
		"loot_pool" : special_loot_pools["oranix"],
		"phases" : [
			{
				"duration" : 4,
				"health" : [25,100],
				"behavior" : 1,
				"attack_pattern" : [
					{
						"projectile" : "GoldDart",
						"formula" : "0",
						"damage" : 250,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : Vector2(0,1),
						"size" : 9
					},
					{
						"projectile" : "GoldDart",
						"formula" : "0",
						"damage" : 250,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : Vector2(0.707,0.707),
						"size" : 9
					},
					{
						"projectile" : "GoldDart",
						"formula" : "0",
						"damage" : 250,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : Vector2(1,0),
						"size" : 9
					},
					{
						"projectile" : "GoldDart",
						"formula" : "0",
						"damage" : 250,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : Vector2(0.707,-0.707),
						"size" : 9
					},
					{
						"projectile" : "GoldDart",
						"formula" : "0",
						"damage" : 250,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : Vector2(0,-1),
						"size" : 9
					},
					{
						"projectile" : "GoldDart",
						"formula" : "0",
						"damage" : 250,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : Vector2(-0.707,-0.707),
						"size" : 9
					},
					{
						"projectile" : "GoldDart",
						"formula" : "0",
						"damage" : 250,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : Vector2(-1,0),
						"size" : 9
					},
					{
						"projectile" : "GoldDart",
						"formula" : "0",
						"damage" : 250,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : Vector2(-0.707,0.707),
						"size" : 9
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 30,
						"tile_range" : 20,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 30,
						"tile_range" : 20,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 30,
						"tile_range" : 20,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 30,
						"tile_range" : 20,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 2,
						"speed" : 30,
						"tile_range" : 20,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : 7
					},
				]
			},
			{
				"duration" : 6,
				"health" : [25,100],
				"behavior" : 1,
				"attack_pattern" : [
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(30),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-30),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(120),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(240),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 13,
						"targeter" : "nearest",
						"direction" : DegreesToVector(60),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 13,
						"targeter" : "nearest",
						"direction" : DegreesToVector(180),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 1,
						"speed" : 40,
						"tile_range" : 13,
						"targeter" : "nearest",
						"direction" : DegreesToVector(300),
						"size" : 7
					},
				]
			},
			{
				"duration" : 6,
				"health" : [25,100],
				"behavior" : 2,
				"attack_pattern" : [
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : 7
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 7
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 7
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(5),
						"size" : 7
					},
				]
			},
			{
				"duration" : 12,
				"health" : [0,25],
				"on_spawn" : true,
				"behavior" : 2,
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 70,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 200,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 50,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 200,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 50,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 200,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 50,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 7
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 14,
						"targeter" : "nearest",
						"direction" : DegreesToVector(120),
						"size" : 7
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 14,
						"targeter" : "nearest",
						"direction" : DegreesToVector(180),
						"size" : 7
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 60,
						"tile_range" : 14,
						"targeter" : "nearest",
						"direction" : DegreesToVector(240),
						"size" : 7
					},
				]
			}
		]
	},
	"vajira" : {
		"health" : 20,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 10,
		"dungeon" : {
			"rate" : 0,
			"name" : "overgrown_temple"
		},
		"loot_pool" : {
			"soulbound_loot" : [
				{
					"item" : 0,
					"chance" : 1,
					"threshold" : 1,
				},
			],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 4,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 0,
						"piercing" : true,
						"wait" : 1000,
						"speed" : 0,
						"tile_range" : 0,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					}
				]
			},
		]
	},
	"raa'sloth" : {
		"health" : 20,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 10,
		"dungeon" : {
			"rate" : 0,
			"name" : "overgrown_temple"
		},
		"loot_pool" : {
			"soulbound_loot" : [
				{
					"item" : 0,
					"chance" : 1,
					"threshold" : 1,
				},
			],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 4,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 0,
						"piercing" : true,
						"wait" : 1000,
						"speed" : 0,
						"tile_range" : 0,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					}
				]
			},
		]
	},
	"salazar" : {
		"health" : 20,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 0,
		"speed" : 10,
		"dungeon" : {
			"rate" : 0,
			"name" : "overgrown_temple"
		},
		"loot_pool" : {
			"soulbound_loot" : [
				{
					"item" : 0,
					"chance" : 1,
					"threshold" : 1,
				},
			],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "salazar_left_wing",
						"summon_position" : Vector2(-14,-1),
						"wait" : 0,
					},
					{
						"summon" : "salazar_right_wing",
						"summon_position" : Vector2(15,-1),
						"wait" : 1,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 0,
						"piercing" : true,
						"wait" : 1000,
						"speed" : 0,
						"tile_range" : 0,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					}
				]
			},
		]
	},
	"salazar_left_wing" : {
		"health" : 200000,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 0,
		"speed" : 10,
		"dungeon" : {
			"rate" : 0,
			"name" : "overgrown_temple"
		},
		"loot_pool" : {
			"soulbound_loot" : [
				{
					"item" : 0,
					"chance" : 1,
					"threshold" : 1,
				},
			],
			"loot" : []
		},
		"phases" : []
	},
	"salazar_right_wing" : {
		"health" : 200000,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 0,
		"speed" : 10,
		"dungeon" : {
			"rate" : 0,
			"name" : "overgrown_temple"
		},
		"loot_pool" : {
			"soulbound_loot" : [
				{
					"item" : 0,
					"chance" : 1,
					"threshold" : 1,
				},
			],
			"loot" : []
		},
		"phases" : []
	},
}
var tutorial_enemies = {
	"tutorial_crab" : {
		"health" : 20,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : {
			"soulbound_loot" : [],
			"loot" : [
				{
					"item" : 400,
					"chance" : 1,
				},
			]
		},
		"phases" : [
			{
				"duration" : 4,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 0,
						"piercing" : true,
						"wait" : 1000,
						"speed" : 0,
						"tile_range" : 0,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					}
				]
			},
		]
	},
	"tutorial_troll_warrior" : {
		"health" : 70,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 2,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(0,1),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 2,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(1,0),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 2,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(0,-1),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 2,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(-1,0),
						"size" : 4
					}
				]
			}
		]
	},
	"tutorial_troll_king" : {
		"health" : 300,
		"defense" : 2,
		"exp" : 30,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  {
			"soulbound_loot" : [
				{
					"item" : 0,
					"chance" : 1,
					"threshold" : 0.2,
				},
			],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 4,
				"health" : [75,100],
				"attack_pattern" : [
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 5,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					}
				]
			},
			{
				"duration" : 4,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,75],
				"attack_pattern" : [
					{
						"summon" : "troll_warrior",
						"summon_position" : Vector2(0,0),
						"wait" : 6,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [0,75],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(1,0),
						"size" : 4
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(-1,0),
						"size" : 4
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(0,1),
						"size" : 4
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 2,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(0,-1),
						"size" : 4
					},
				]
			}
		]
	},
}
var realm_enemies = {
	"crab" : {
		"variations" : ["tutorial_crab"],
		"health" : 50,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 2,
						"piercing" : false,
						"wait" : 3,
						"speed" : 10,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 8
					},
				]
			}
		]
	},
	"slime" : {
		"health" : 50,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "GreenBlast",
						"formula" : "2",
						"damage" : 4,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 8
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "(-2)",
						"damage" : 4,
						"piercing" : false,
						"wait" : 3,
						"speed" : 20,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 8
					}
				]
			}
		]
	},
	"nature_druid" : {
		"health" : 300,
		"defense" : 3,
		"exp" : 43,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  basic_loot_pools["lowlands_2"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "nature_sprite_stationary",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite_stationary",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite_stationary",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 3,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Nature2",
						"formula" : "sin(x)",
						"damage" : 7,
						"piercing" : false,
						"wait" : 2,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "sin(x)",
						"damage" : 2,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"direction" : Vector2(0,1),
						"size" : 7
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "sin(x)",
						"damage" : 2,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"direction" : Vector2(0.707,0.707),
						"size" : 7
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "sin(x)",
						"damage" : 2,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"direction" : Vector2(1,0),
						"size" : 7
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "sin(x)",
						"damage" : 2,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"direction" : Vector2(0.707,-0.707),
						"size" : 7
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "sin(x)",
						"damage" : 2,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"direction" : Vector2(0,-1),
						"size" : 7
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "sin(x)",
						"damage" : 2,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"direction" : Vector2(-0.707,-0.707),
						"size" : 7
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "sin(x)",
						"damage" : 2,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"direction" : Vector2(-1,0),
						"size" : 7
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "sin(x)",
						"damage" : 2,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"direction" : Vector2(-0.707,0.707),
						"size" : 7
					},
				]
			},
			{
				"duration" : 1,
				"max_uses" : 1,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"summon" : "nature_sprite",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 2,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"projectile" : "Nature2",
						"formula" : "sin(x)",
						"damage" : 7,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 30,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 7
					}
				]
			},
		]
	},
	"nature_sprite_stationary" : {
		"health" : 40,
		"defense" : 0,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 6,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Nature1",
						"formula" : "0",
						"damage" : 3,
						"piercing" : false,
						"wait" : 3,
						"speed" : 30,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					}
				]
			}
		]
	},
	"nature_sprite" : {
		"variations" : ["nature_sprite_stationary"],
		"health" : 10,
		"defense" : 0,
		"exp" : 10,
		"behavior" : 2,
		"speed" : 35,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Nature1",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					}
				]
			}
		]
	},
	"goblin_warrior" : {
		"health" : 60,
		"defense" : 3,
		"exp" : 10,
		"behavior" : 2,
		"speed" : 15,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "IronSlash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 5,
						"speed" : 10,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					}
				]
			}
		]
	},
	"goblin_archer" : {
		"health" : 30,
		"defense" : 0,
		"exp" : 10,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 12,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "SteelArrow",
						"formula" : "0",
						"damage" : 4,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
					{
						"projectile" : "SteelArrow",
						"formula" : "0",
						"damage" : 4,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 6
					},
					{
						"projectile" : "SteelArrow",
						"formula" : "0",
						"damage" : 4,
						"piercing" : true,
						"wait" : 6,
						"speed" : 20,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 6
					}
				]
			}
		]
	},
	"goblin_cannon" : {
		"health" : 20,
		"defense" : 1000,
		"exp" : 45,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" :  basic_loot_pools["lowlands_2"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "goblin_warrior",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "goblin_archer",
						"summon_position" : Vector2(0,-10),
						"wait" : 0,
					},
					{
						"summon" : "goblin_archer",
						"summon_position" : Vector2(0,10),
						"wait" : 0,
					},
					{
						"summon" : "goblin_warrior",
						"summon_position" : Vector2(-10,0),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 7,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "CannonBall",
						"formula" : "0",
						"damage" : 30,
						"piercing" : true,
						"wait" : 7,
						"speed" : 12,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 5
					}
				]
			},
		]
	},
	"blue_slime" : {
		"health" : 700,
		"defense" : 1,
		"exp" : 45,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "slime",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "slime",
						"summon_position" : Vector2(0,-10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 70,
						"tile_range" : 7,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
					{
						"projectile" : "Water1",
						"formula" : "0",
						"damage" : 5,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 70,
						"tile_range" : 7,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 3
					},
					{
						"projectile" : "Water1",
						"formula" : "0",
						"damage" : 5,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 70,
						"tile_range" : 7,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 3
					}
				]
			}
		]
	},
	"cyclops_underling" : {
		"health" : 50,
		"defense" : 0,
		"exp" : 13,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 3,
						"speed" : 20,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
				]
			}
		]
	},
	"cyclops_leader" : {
		"health" : 300,
		"defense" : 5,
		"exp" : 89,
		"behavior" : 1,
		"speed" : 6,
		"loot_pool" : basic_loot_pools["midlands_2"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "cyclops_underling",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "cyclops_underling",
						"summon_position" : Vector2(0,-10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 15,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 4
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 2,
						"speed" : 40,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 4
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 7,
						"direction" : Vector2(0,1),
						"size" : 7
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 7,
						"direction" : Vector2(0.866,0.5),
						"size" : 7
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 7,
						"direction" : Vector2(0.866,-0.5),
						"size" : 7
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 7,
						"direction" : Vector2(0,-1),
						"size" : 7
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 7,
						"direction" : Vector2(-0.866,-0.5),
						"size" : 7
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 7,
						"direction" : Vector2(-0.866,0.5),
						"size" : 7
					},
				]
			}
		]
	},
	"imp_warrior" : {
		"health" : 200,
		"defense" : 5,
		"exp" : 35,
		"behavior" : 2,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "imp_archer",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "imp_mage",
						"summon_position" : Vector2(0,-10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 70,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 25,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 50,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 2,
						"speed" : 35,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
				]
			}
		]
	},
	"imp_archer" : {
		"health" : 100,
		"defense" : 0,
		"exp" : 35,
		"behavior" : 2,
		"speed" : 8,
		"loot_pool" : basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 30,
						"piercing" : true,
						"wait" : 0,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 30,
						"piercing" : true,
						"wait" : 0,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 4
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 30,
						"piercing" : true,
						"wait" : 6,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 4
					},
				]
			}
		]
	},
	"imp_mage" : {
		"health" : 100,
		"defense" : 0,
		"exp" : 35,
		"behavior" : 2,
		"speed" : 7,
		"loot_pool" : basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "BlueBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 4
					},
					{
						"projectile" : "BlueBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 1,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 4
					},
				]
			}
		]
	},
	"fire_druid" : {
		"health" : 200,
		"defense" : 0,
		"exp" : 43,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  basic_loot_pools["midlands_2"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 12,
						"piercing" : false,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(5),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 12,
						"piercing" : false,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-5),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 12,
						"piercing" : false,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 12,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 24,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(5),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 24,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-5),
						"size" : 7
					},
					{
						"projectile" : "Fire3",
						"formula" : "0",
						"damage" : 32,
						"piercing" : false,
						"wait" : 6,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
				]
			}
		]
	},
	"troll_warrior" : {
		"variations" : ["tutorial_troll_warrior"],
		"health" : 100,
		"defense" : 1,
		"exp" : 6,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" :  basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(0,1),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(1,0),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(0,-1),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(-1,0),
						"size" : 4
					}
				]
			}
		]
	},
	"troll_brute" : {
		"health" : 200,
		"defense" : 5,
		"exp" : 12,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					}
				]
			}
		]
	},
	"troll_king" : {
		"variations" : ["tutorial_troll_king"],
		"health" : 300,
		"defense" : 5,
		"exp" : 64,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" :  basic_loot_pools["midlands_2"],
		"phases" : [
			{
				"duration" : 6,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 50,
						"piercing" : true,
						"wait" : 0,
						"speed" : 5,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 6
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 5,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					}
				]
			},
			{
				"duration" : 4,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "troll_warrior",
						"summon_position" : Vector2(-10,0),
						"wait" : 0.2,
					},
					{
						"summon" : "troll_warrior",
						"summon_position" : Vector2(10,0),
						"wait" : 0.2,
					},
					{
						"summon" : "troll_brute",
						"summon_position" : Vector2(0,-10),
						"wait" : 0.2,
					},
					{
						"summon" : "troll_brute",
						"summon_position" : Vector2(0,10),
						"wait" : 4,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(1,0),
						"size" : 20
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(-1,0),
						"size" : 20
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(0,1),
						"size" : 20
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 2,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(0,-1),
						"size" : 20
					},
				]
			}
		]
	},
	"rat_warrior" : {
		"health" : 100,
		"defense" : 6,
		"exp" : 24,
		"behavior" : 2,
		"speed" : 40,
		"loot_pool" :  basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "IronSlash",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 7
					},
					{
						"projectile" : "IronSlash",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 2.5,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 7
					},
				]
			}
		]
	},
	"rat_mage" : {
		"health" : 250,
		"defense" : 0,
		"exp" : 24,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "BrownBlast",
						"formula" : "0",
						"damage" : 25,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 5
					},
					{
						"projectile" : "BrownBlast",
						"formula" : "0",
						"damage" : 25,
						"piercing" : false,
						"wait" : 2,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 5
					},
					{
						"projectile" : "BrownBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 2,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 5
					},
				]
			}
		]
	},
	"rat_king" : {
		"health" : 600,
		"defense" : 4,
		"exp" : 200,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["highlands_2"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"summon" : "rat_warrior",
						"summon_position" : Vector2(-10,0),
						"wait" : 0.1,
					},
					{
						"summon" : "rat_mage",
						"summon_position" : Vector2(0,10),
						"wait" : 0.1,
					},
					{
						"summon" : "rat_mage",
						"summon_position" : Vector2(0,-10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 7
					},
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 7
					},
				]
			},
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 7
					},
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 2.5,
						"speed" : 50,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 7
					},
				]
			}
		]
	},
	"viking_king" : {
		"health" : 1200,
		"defense" : 12,
		"exp" : 340,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["highlands_2"],
		"phases" : [
			{
				"duration" : 2,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "viking_warrior",
						"summon_position" : Vector2(-10,-5),
						"wait" : 0.1,
					},
					{
						"summon" : "viking_warrior",
						"summon_position" : Vector2(10,-5),
						"wait" : 0.1,
					},
					{
						"summon" : "viking_warrior",
						"summon_position" : Vector2(0,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(0,1),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(0.707,0.707),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(1,0),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(0.707,-0.707),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(0,-1),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(-0.707,-0.707),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(-1,0),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 2,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(-0.707,0.707),
						"size" : 7
					},
					{
						"projectile" : "Spinner",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-17),
						"size" : 7
					},
					{
						"projectile" : "Spinner",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(17),
						"size" : 7
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 5
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(35),
						"size" : 5
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-35),
						"size" : 5
					},
				]
			},
		]
	},
	"viking_warrior" : {
		"health" : 180,
		"defense" : 0,
		"exp" : 140,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 20,
						"tile_range" : 2,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 20,
						"tile_range" : 2,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 3,
						"speed" : 20,
						"tile_range" : 2,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
				]
			}
		]
	},
	"yellow_slime" : {
		"health" : 1000,
		"defense" : 0,
		"exp" : 150,
		"behavior" : 1,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["highlands_2"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 6
					},
					{
						"projectile" : "Fire3",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 6
					},
				]
			},
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "blue_slime",
						"summon_position" : Vector2(10,10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 6
					},
					{
						"projectile" : "Fire3",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 7
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 6
					},
				]
			},
		]
	},
	"shadow_druid" : {
		"health" : 300,
		"defense" : 22,
		"exp" : 200,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  basic_loot_pools["highlands_2"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "skeletal_warrior",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "skeletal_archer",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "skeletal_archer",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"summon" : "skeletal_warrior",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "skeletal_archer",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "skeletal_archer",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 70,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(35),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 3,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-35),
						"size" : 7
					},
				]
			},
			{
				"duration" : 3,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(35),
						"size" : 7
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 1,
						"speed" : 20,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-35),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-35),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(35),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 1,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
				]
			},
		]
	},
	"skeletal_warrior" : {
		"health" : 180,
		"defense" : 22,
		"exp" : 35,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 30,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.8,
						"speed" : 35,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
				]
			}
		]
	},
	"skeletal_archer" : {
		"health" : 90,
		"defense" : 10,
		"exp" : 35,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "RexiumArrow",
						"formula" : "0",
						"damage" : 20,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 45,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
					{
						"projectile" : "RexiumArrow",
						"formula" : "0",
						"damage" : 20,
						"piercing" : true,
						"wait" : 4,
						"speed" : 35,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
				]
			}
		]
	},
	"cacodemon" : {
		"health" : 1200,
		"defense" : 12,
		"exp" : 200,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(0,1),
						"size" : 7
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(0.866,0.5),
						"size" : 7
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(0.866,-0.5),
						"size" : 7
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(0,-1),
						"size" : 7
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(-0.866,-0.5),
						"size" : 7
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(-0.866,0.5),
						"size" : 7
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 40,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : DegreesToVector(7),
						"size" : 7
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 60,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 7
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 50,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-7),
						"size" : 7
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : 60,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 7
					},
				]
			},
		]
	},
	"basalisk" : {
		"health" : 1000,
		"defense" : 18,
		"exp" : 250,
		"behavior" : 2,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "MithrilSlash",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 7
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 1.4,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 7
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "MithrilSlash",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 7
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : 7
					},
					{
						"projectile" : "MithrilSlash",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 7
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 1.4,
						"speed" : 40,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : 7
					},
				]
			},
		]
	},
	"phoenix" : {
		"health" : 800,
		"defense" : 15,
		"exp" : 180,
		"behavior" : 2,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(40),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(60),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(40),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-40),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-60),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-40),
						"size" : 7
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 60,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : 7
					},
				]
			},
		]
	},
	"ice_druid" : {
		"health" : 90,
		"defense" : 10,
		"exp" : 55,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "RedBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 45,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 6
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 45,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 6
					},
					{
						"projectile" : "BlueBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 4,
						"speed" : 45,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 6
					},
				]
			}
		]
	},
	"archmage" : {
		"health" : 700,
		"defense" : 15,
		"exp" : 225,
		"behavior" : 1,
		"speed" : 7,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "ice_druid",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "ice_druid",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "ice_druid",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "BlueBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(60),
						"size" : 5
					},
					{
						"projectile" : "RedBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(180),
						"size" : 5
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 1.5,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(300),
						"size" : 5
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 120,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 120,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(120),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 120,
						"piercing" : false,
						"wait" : 1.5,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(240),
						"size" : 7
					},
				]
			},
		]
	},
}
var orc_vigil_enemies = {
	"vigil_guardian" : {
		"health" : 20000,
		"defense" : 20,
		"exp" : 6000,
		"behavior" : 0,
		"speed" : 15,
		"dungeon" : {
			"rate" : 1,
			"name" : "orc_vigil_sanctum"
		},
		"loot_pool" : special_loot_pools["vigil_guardian"],
		"phases" : [
			{
				"duration" : 16,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 16,
						"wait" : 12,
					},
					{
						"speech" : "So Oranix has fallen? The creator will be angry...",
						"wait" : 2,
					},
					{
						"speech" : "No matter. Those who enter the vigil shall not return. Die usurper!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 12,
				"health" : [90,100],
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 30,
						"tile_range" : 20,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : 9
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 30,
						"tile_range" : 20,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : 9
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 45,
						"piercing" : false,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 8,
						"direction" : Vector2(0,1),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 45,
						"piercing" : false,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 8,
						"direction" : Vector2(0.707,0.707),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 45,
						"piercing" : false,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 8,
						"direction" : Vector2(1,0),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 45,
						"piercing" : false,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 8,
						"direction" : Vector2(0.707,-0.707),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 45,
						"piercing" : false,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 8,
						"direction" : Vector2(0,-1),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 45,
						"piercing" : false,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 8,
						"direction" : Vector2(-0.707,-0.707),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 45,
						"piercing" : false,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 8,
						"direction" : Vector2(-1,0),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 45,
						"piercing" : false,
						"wait" : 1.5,
						"speed" : 25,
						"tile_range" : 8,
						"direction" : Vector2(-0.707,0.707),
						"size" : 7
					},
				]
			},
			{
				"duration" : 4,
				"health" : [50,90],
				"behavior" : 2,
				"speed" : 20,
				"attack_pattern" : [
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0,
						"speed" : 30,
						"tile_range" : 20,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0,
						"speed" : 30,
						"tile_range" : 20,
						"targeter" : "nearest",
						"direction" : DegreesToVector(120),
						"size" : 7
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0,
						"speed" : 30,
						"tile_range" : 20,
						"targeter" : "nearest",
						"direction" : DegreesToVector(240),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 6,
						"direction" : Vector2(0,1),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 6,
						"direction" : Vector2(0.707,0.707),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 6,
						"direction" : Vector2(1,0),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 6,
						"direction" : Vector2(0.707,-0.707),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 6,
						"direction" : Vector2(0,-1),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 6,
						"direction" : Vector2(-0.707,-0.707),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 6,
						"direction" : Vector2(-1,0),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0.7,
						"speed" : 70,
						"tile_range" : 6,
						"direction" : Vector2(-0.707,0.707),
						"size" : 6
					},
				]
			},
			{
				"duration" : 4,
				"health" : [50,90],
				"behavior" : 0,
				"speed" : 20,
				"attack_pattern" : [
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(0,1),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(0.434,0.901),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(0.782,0.623),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(0.975,0.223),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(0.975,-0.223),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(0.782,-0.623),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(0.434,-0.901),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(0,-1),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(-0.434,-0.901),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(-0.782,-0.623),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(-0.975,-0.223),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(-0.975,0.223),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(-0.782,0.623),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 20,
						"tile_range" : 12,
						"direction" : Vector2(-0.434,0.901),
						"size" : 6
					},
				]
			},
			{
				"duration" : 4,
				"health" : [20,50],
				"behavior" : 0,
				"on_spawn" : true,
				"max_uses" : 1,
				"speed" : 10,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 0,
					},
					{
						"speech" : "I have stood guard of this vigil for a millenium...",
						"wait" : 2,
					},
					{
						"speech" : "I will not fall to you lowly bottomfeeders!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [20,50],
				"behavior" : 2,
				"speed" : 10,
				"attack_pattern" : [
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 30,
						"tile_range" : 12,
						"direction" : DegreesToVector(0),
						"size" : 9
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(30),
						"size" : 5
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 30,
						"tile_range" : 12,
						"direction" : DegreesToVector(30),
						"size" : 9
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 30,
						"tile_range" : 12,
						"direction" : DegreesToVector(60),
						"size" : 9
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 30,
						"tile_range" : 12,
						"direction" : DegreesToVector(90),
						"size" : 9
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(120),
						"size" : 5
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 30,
						"tile_range" : 12,
						"direction" : DegreesToVector(120),
						"size" : 9
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 30,
						"tile_range" : 12,
						"direction" : DegreesToVector(150),
						"size" : 9
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 30,
						"tile_range" : 12,
						"direction" : DegreesToVector(180),
						"size" : 9
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 5
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 30,
						"tile_range" : 12,
						"direction" : DegreesToVector(210),
						"size" : 9
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 30,
						"tile_range" : 12,
						"direction" : DegreesToVector(240),
						"size" : 9
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 30,
						"tile_range" : 12,
						"direction" : DegreesToVector(270),
						"size" : 9
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(90),
						"size" : 5
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 30,
						"tile_range" : 12,
						"direction" : DegreesToVector(300),
						"size" : 9
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 70,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 70,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 7
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(330),
						"size" : 5
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 70,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : 7
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(270),
						"size" : 5
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 70,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(30),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 70,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 70,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : 7
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 70,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-30),
						"size" : 7
					},
				]
			},
		]
	},
	"orc_monolith" : {
		"health" : 2000,
		"defense" : 1,
		"exp" : 2000,
		"behavior" : 0,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 16,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 16,
						"wait" : 17,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "NeonArrow",
						"formula" : "0",
						"damage" : 40,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"direction" : DegreesToVector(0),
						"size" : 5
					},
					{
						"projectile" : "NeonArrow",
						"formula" : "0",
						"damage" : 40,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"direction" : DegreesToVector(90),
						"size" : 5
					},
					{
						"projectile" : "NeonArrow",
						"formula" : "0",
						"damage" : 40,
						"piercing" : true,
						"wait" : 0,
						"speed" : 20,
						"tile_range" : 10,
						"direction" : DegreesToVector(180),
						"size" : 5
					},
					{
						"projectile" : "NeonArrow",
						"formula" : "0",
						"damage" : 40,
						"piercing" : true,
						"wait" : 1,
						"speed" : 20,
						"tile_range" : 10,
						"direction" : DegreesToVector(270),
						"size" : 5
					},
				]
			}
		]
	},
	"atlas" : {
		"health" : 20000,
		"defense" : 10,
		"exp" : 10000,
		"behavior" : 0,
		"speed" : 15,
		"loot_pool" : special_loot_pools["atlas"],
		"phases" : [
			{
				"duration" : 18,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 18,
						"wait" : 12,
					},
					{
						"speech" : "This vigil is the only remnant of the old orc empire...",
						"wait" : 2,
					},
					{
						"speech" : "Do you really think it's treasures would lie undefended?",
						"wait" : 2,
					},
					{
						"speech" : "Prepare yourselves!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 3,
				"max_uses" : 3,
				"behavior" : 0,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"speech" : "Bare witness to the power of orc magicks!",
						"wait" : 1,
					},
					{
						"summon" : "vigil_construct",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "vigil_construct",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "vigil_construct",
						"summon_position" : Vector2(-10,5),
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 6,
				"health" : [75,100],
				"behavior" : 1,
				"attack_pattern" : [
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(30),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(60),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(90),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 2,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(120),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-30),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"direction" : DegreesToVector(-60),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-90),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : true,
						"wait" : 2,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-120),
						"size" : 7
					},
				]
			},
			{
				"duration" : 8,
				"health" : [75,100],
				"behavior" : 2,
				"speed" : 15,
				"attack_pattern" : [
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 9
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(180),
						"size" : 5
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 80,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-45),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 120,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-5),
						"size" : 7
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(220),
						"size" : 5
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 80,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 9
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(160),
						"size" : 5
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 80,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(30),
						"size" : 7
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(200),
						"size" : 5
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 120,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 7
					},
				]
			},
			{
				"duration" : 8,
				"health" : [25,75],
				"behavior" : 2,
				"speed" : 5,
				"attack_pattern" : [
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(90),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(180),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(270),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(45),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(45+90),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(45+180),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(45+270),
						"size" : 7
					},
					{
						"projectile" : "NeonArrow",
						"formula" : "0",
						"damage" : 50,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "NeonArrow",
						"formula" : "0",
						"damage" : 50,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "NeonArrow",
						"formula" : "0",
						"damage" : 50,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "NeonArrow",
						"formula" : "0",
						"damage" : 50,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "NeonArrow",
						"formula" : "0",
						"damage" : 50,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "NeonArrow",
						"formula" : "0",
						"damage" : 50,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "NeonArrow",
						"formula" : "0",
						"damage" : 50,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
				]
			},
			{
				"duration" : 8,
				"health" : [0,25],
				"behavior" : 2,
				"speed" : 15,
				"attack_pattern" : [
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(90),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(180),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(270),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(45),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(45+90),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(45+180),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(45+270),
						"size" : 7
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 9
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(180),
						"size" : 5
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 80,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-45),
						"size" : 7
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 120,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-5),
						"size" : 7
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(220),
						"size" : 5
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 80,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 7
					},
					{
						"projectile" : "GiantBlast",
						"formula" : "0",
						"damage" : 190,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 9
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(160),
						"size" : 5
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 80,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(30),
						"size" : 7
					},
					{
						"projectile" : "NeonStar",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 12,
						"targeter" : "nearest",
						"direction" : DegreesToVector(200),
						"size" : 5
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 120,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : 60,
						"tile_range" : 15,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 7
					},
				]
			},
		]
	},
	"vigil_construct" : {
		"health" : 4000,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 2,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 5,
						"direction" : Vector2(0,1),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 5,
						"direction" : Vector2(0.951,0.309),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 5,
						"direction" : Vector2(0.588,-0.809),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 5,
						"direction" : Vector2(-0.588,-0.809),
						"size" : 7
					},
					{
						"projectile" : "VigilBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 2,
						"speed" : 70,
						"tile_range" : 5,
						"direction" : Vector2(-0.951,0.309),
						"size" : 7
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 7,
						"direction" : Vector2(0,1),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 7,
						"direction" : Vector2(0.707,0.707),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 7,
						"direction" : Vector2(1,0),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 7,
						"direction" : Vector2(0.707,-0.707),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 7,
						"direction" : Vector2(0,-1),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 7,
						"direction" : Vector2(-0.707,-0.707),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : 70,
						"tile_range" : 7,
						"direction" : Vector2(-1,0),
						"size" : 6
					},
					{
						"projectile" : "VigilBlastSmall",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 2,
						"speed" : 70,
						"tile_range" : 7,
						"direction" : Vector2(-0.707,0.707),
						"size" : 6
					},
				]
			},
		]
	},
}
var enemies = CompileEnemies()
func CompileEnemies():
	var res = {}
	res.merge(rulers)
	res.merge(tutorial_enemies)
	res.merge(realm_enemies)
	res.merge(orc_vigil_enemies)
	return res

var items = {
	0 : {
		"name": "Ascension Stone",
		"description" : "A precious gemstone, what will it awaken in you?",
		"tier" : "4",
		"type" : "Consumable",
		"use" : "ascend",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,13)],
	},
	100 : {
		"name": "Short Sword",
		"description" : "A simple yet effective weapon.",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "0",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [15,25],
				"projectile" : "IronSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(105.0, 51.0, 10.0),
			"weaponNew" : RgbToColor(174.0, 172.0, 156.0)
		},
		"textures" : {}
	},
	101 : {
		"name": "Gold Sword",
		"description" : "A sword that is equally as effective as it is flashy",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "1",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [25,35],
				"projectile" : "GoldSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(161.0, 87.0, 8.0),
			"weaponNew" : RgbToColor(231.0, 211.0, 61.0)
		},
		"textures" : {}
	},
	102 : {
		"name": "Platinum Sword",
		"description" : "A razor sharp blade made from a precious metal",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "2",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [40,55],
				"projectile" : "PlatinumSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(161.0, 87.0, 8.0),
			"weaponNew" : RgbToColor(231.0, 211.0, 61.0)
		},
		"textures" : {}
	},
	103 : {
		"name": "Mithril Sword",
		"description" : "A sword made from an impossibly light and durable blue metal",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "3",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [65,90],
				"projectile" : "MithrilSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(74.0, 33.0, 4.0),
			"weaponNew" : RgbToColor(25.0, 182.0, 182.0)
		},
		"textures" : {}
	},
	104 : {
		"name": "Rexium Sword",
		"description" : "A sword capable of slicing worlds",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "4",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [80,110],
				"projectile" : "RexiumSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(231.0, 211.0, 61.0),
			"weaponNew" : RgbToColor(134.0, 2.0, 141.0)
		},
		"textures" : {}
	},
	105 : {
		"name": "Warlords Vigil",
		"description" : "An axe unbeknownst to mankind",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "UT",
		
		"rof" : 150,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [80,110],
				"projectile" : "Dart",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			},
			{
				"damage" : [80,110],
				"projectile" : "Dart",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(25),
			},
			{
				"damage" : [80,110],
				"projectile" : "Dart",
				"formula" : "0",
				"piercing" : false,
				"speed" : 50,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(-25),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(7,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(231.0, 211.0, 61.0),
			"weaponNew" : RgbToColor(134.0, 2.0, 141.0)
		},
		"textures" : {}
	},
	133 : {
		"name": "Wand of Fire",
		"description" : "A wooden wand with a fire spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "0",
		
		"rof" : 150,
		"stats" : {
		
		},
		"projectiles" : [
			{
				"damage" : [10,15],
				"projectile" : "Fire1",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 7,
				"size" : 3,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(9,3)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(105.0, 51.0, 10.0)
		},
		"textures" : {
		}
	},
	134 : {
		"name": "Staff of Fire",
		"description" : "A  with a fire spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "2",
		
		"rof" : 150,
		"stats" : {
		
		},
		
		"projectiles" : [
			{
				"damage" : [25,30],
				"projectile" : "Fire2",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 7,
				"size" : 3,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(10,3)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(232.0, 210.0, 65.0)
		},
		"textures" : {
		}
	},
	135 : {
		"name": "Sceptre of Fire",
		"description" : "A powerful sceptre with a fire spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "4",
		
		"rof" : 150,
		"stats" : {
					
		},
		
		"projectiles" : [
			{
				"damage" : [50,60],
				"projectile" : "Fire3",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 7,
				"size" : 3,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(11,3)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(232.0, 210.0, 65.0)
		},
		"textures" : {
		}
	},
	500 : {
		"name": "Iron Platebody",
		"description" : "A beginner warriors only protection from death",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "0",
		
		"stats" : {
			"defense" : 6
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(157.0, 153.0, 135.0),
			"bodyLightNew" : RgbToColor(174.0, 172.0, 156.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	501 : {
		"name": "Gold Platebody",
		"description" : "A regal platebody for a strong warrior",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "1",
		
		"stats" : {
			"defense" : 8
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(207.0, 189.0, 56.0),
			"bodyLightNew" : RgbToColor(231.0, 211.0, 61.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	502 : {
		"name": "Platinum Platebody",
		"description" : "A premium armor made from a premium metal",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "2",
		
		"stats" : {
			"defense" : 12
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(204.0, 203.0, 197.0),
			"bodyLightNew" : RgbToColor(209.0, 208.0, 205.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	503 : {
		"name": "Mithril Platebody",
		"description" : "An armor capable of deflecting fearsome blows",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "3",
		
		"stats" : {
			"defense" : 16
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(23.0, 163.0, 163.0),
			"bodyLightNew" : RgbToColor(25.0, 182.0, 182.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	504 : {
		"name": "Rexium Platebody",
		"description" : "A magic alloy forms the strongest armor imaginable",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "4",
		
		"stats" : {
			"defense" : 20
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(108.0, 2.0, 113.0),
			"bodyLightNew" : RgbToColor(134.0, 2.0, 141.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	533 : {
		"name": "Worn robe",
		"description" : "A flimsy robe",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "0",
		
		"stats" : {
			"defense" : 1,
			"attack" : 1
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(105, 51.0, 10.0),
			"bodyLightNew" : RgbToColor(123.0, 72.0, 17.0),
			"bandNew" : RgbToColor(83.0, 39.0, 6.0),
		},
		"textures" : {
			
		}
	},
	534 : {
		"name": "Leather robe",
		"description" : "a fine leather robe",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "1",
		
		"stats" : {
			"defense" : 2,
			"attack" : 2
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(161.0, 87.0, 8.0),
			"bodyLightNew" : RgbToColor(184.0, 99.0, 8.0),
			"bandNew" : RgbToColor(190.0, 168.0, 48.0),
		},
		"textures" : {
			
		}
	},
	535 : {
		"name": "Magic robe",
		"description" : "a wizard's robe imbued with a magic spell",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "2",
		
		"stats" : {
			"defense" : 3,
			"attack" : 4
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(23.0, 163.0, 163.0),
			"bodyLightNew" : RgbToColor(25.0, 182.0, 182.0),
			"bandNew" : RgbToColor(225.0, 222.0, 213.0),
		},
		"textures" : {
			
		}
	},
	536 : {
		"name": "Dragonhide robe",
		"description" : "a powerful robe made from the skin of a dragon",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "3",
		
		"stats" : {
			"defense" : 5,
			"attack" : 7
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(160.0, 18.0, 0.0),
			"bodyLightNew" : RgbToColor(25.0, 182.0, 182.0),
			"bandNew" : RgbToColor(188.0, 21.0, 0.0),
		},
		"textures" : {
			
		}
	},
	537 : {
		"name": "Master's robe",
		"description" : "a robe made for master wizards and magicians",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "4",
		
		"stats" : {
			"defense" : 6,
			"attack" : 10
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(0.0, 106.0, 138.0),
			"bodyLightNew" : RgbToColor(0.0, 125.0, 163.0),
			"bandNew" : RgbToColor(231.0, 211.0, 61.0),
		},
		"textures" : {
			
		}
	},
	566 : {
		"name": "Worn tunic",
		"description" : "An old tunic not worth its weight in fabric",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "0",
		
		"stats" : {
			"speed" : 2,
			"defense" : 1 
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(105, 51.0, 10.0),
			"bodyLightNew" : RgbToColor(123.0, 72.0, 17.0),
			"bandNew" : RgbToColor(83.0, 39.0, 6.0),
		},
		"textures" : {
			
		}
	},
	567 : {
		"name": "Leather tunic",
		"description" : "A simple leather tunic",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "1",
		
		"stats" : {
			"speed" : 3,
			"defense" : 3 
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(161, 87.0, 8.0),
			"bodyLightNew" : RgbToColor(184.0, 99.0, 8.0),
			"bandNew" : RgbToColor(207.0, 189.0, 56.0),
		},
		"textures" : {
			
		}
	},
	568 : {
		"name": "Magic tunic",
		"description" : "A tunic imbued with magical properties",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "2",
		
		"stats" : {
			"speed" : 4,
			"defense" : 5
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(23.0, 163.0, 163.0),
			"bodyLightNew" : RgbToColor(25.0, 182.0, 182.0),
			"bandNew" : RgbToColor(225.0, 222.0, 213.0),
		},
		"textures" : {
			
		}
	},
	569 : {
		"name": "Dragonhide tunic",
		"description" : "A powerful tunic made from the hide of a powerful dragon",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "3",
		
		"stats" : {
			"speed" : 5,
			"defense" : 7
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(114.0, 12.0, 0.0),
			"bodyLightNew" : RgbToColor(160.0, 18.0, 0.0),
			"bandNew" : RgbToColor(213.0, 213.0, 148.0),
		},
		"textures" : {
			
		}
	},
	570 : {
		"name": "Master's tunic",
		"description" : "A tunic made for a master archer",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "4",
		
		"stats" : {
			"speed" : 6,
			"defense" : 10
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(231.0, 211.0, 61.0),
			"bodyLightNew" : RgbToColor(2.0, 131.0, 116.0),
			"bandNew" : RgbToColor(2.0, 131.0, 116.0),
		},
		"textures" : {
			
		}
	},
	400 : {
		"name": "Iron Helmet",
		"description" : "A basic helmet that has seen many battles.",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 4, "range" : 5},
		},
		"stats" : {
			"defense" : 5,
			"vitality" : 5,
		},
		"tier" : "0",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,8)],
		"colors" : {
			"helmetMediumNew" : RgbToColor(157.0, 153.0, 135.0),
			"helmetLightNew" : RgbToColor(174.0, 172.0, 156.0),
			"helmetDarkNew" : RgbToColor(157.0, 153.0, 135.0),
		},
		"textures" : {
			
		}
	},
	401 : {
		"name": "Gold Helmet",
		"description" : "A sturdy gold helmet",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 5, "range" : 5},
		},
		"stats" : {
			"defense" : 7,
			"vitality" : 7,
		},
		"tier" : "1",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(231.0, 211.0, 61.0),
			"helmetMediumNew" : RgbToColor(207.0, 189.0, 56.0),
			"helmetDarkNew" : RgbToColor(190.0, 168.0, 48.0),
		},
		"textures" : {
			
		}
	},
	402 : {
		"name": "Platinum Helmet",
		"description" : "A durable helmet made out of a premium platinum alloy",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 6, "range" : 5},
		},
		"stats" : {
			"defense" : 9,
			"vitality" : 9,
		},
		"tier" : "2",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(209.0, 208.0, 205.0),
			"helmetMediumNew" : RgbToColor(204.0, 203.0, 197.0),
			"helmetDarkNew" : RgbToColor(195.0, 195.0, 195.0),
		},
		"textures" : {
			
		}
	},
	403 : {
		"name": "Mithril Helmet",
		"description" : "A perfectly crafted helmet made from a magic ore",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 6.5, "range" : 5},
		},
		"stats" : {
			"defense" : 10,
			"vitality" : 10,
		},
		"tier" : "3",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(25.0, 182.0, 182.0),
			"helmetMediumNew" : RgbToColor(23.0, 163.0, 163.0),
			"helmetDarkNew" : RgbToColor(20.0, 140.0, 140.0),
		},
		"textures" : {
			
		}
	},
	404 : {
		"name": "Rexium Helmet",
		"description" : "You wont find a helmet stronger than this",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 8, "range" : 5},
		},
		"stats" : {
			"defense" : 15,
			"vitality" : 15,
		},
		"tier" : "4",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(134.0, 2.0, 141.0),
			"helmetMediumNew" : RgbToColor(108.0, 2.0, 113.0),
			"helmetDarkNew" : RgbToColor(90.0, 16.0, 82.0),
		},
		"textures" : {
			
		}
	},
}

var buildings = {
	"storage" : {
		"name" : "Storage Chest",
		"type" : "object",
		"catagory" : "storage",
		"description" : "For storing up to 8 items.",
		
		"craftable" : true,
		"materials" : [0,0,1],
		"max" : 20,
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(50,40)],
	},
	"grass" : {
		"name" : "Grass Tile",
		"type" : "tile",
		"description" : "Don't forget to water.",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["tiles/tileset.png", 26, 26, Vector2(0,60)],
		"tile" : 2,
	},
	"stone" : {
		"name" : "Stone Tile",
		"type" : "tile",
		"description" : "Hard as rock.",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["tiles/tileset.png", 26, 26, Vector2(70,60)],
		"tile" : 3,
	},
	"stone_wall" : {
		"name" : "Stone Wall",
		"type" : "tile",
		"description" : "Fortress strength in every block.",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["tiles/tileset.png", 26, 26, Vector2(130,70)],
		"tile" : 4,
	},
	"wooden_planks" : {
		"name" : "Wooden Planks",
		"type" : "tile",
		"description" : "Straight from the docks.",
		
		"craftable" : true,
		"materials" : [0,0,0],
		"max" : 20,
		"path" : ["tiles/tileset.png", 26, 26, Vector2(140,60)],
		"tile" : 5,
	},
	"wooden_wall" : {
		"name" : "Wooden Wall",
		"type" : "tile",
		"description" : "Carved with care, built to last.",
		
		"craftable" : true,
		"materials" : [0,0,0],
		"max" : 20,
		"path" : ["tiles/tileset.png", 26, 26, Vector2(140,60)],
		"tile" : 6,
	},
	"apprentice_statue" : {
		"name" : "Apprentice Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a health boost (2m).",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(60,40)],
	},
	"noble_statue" : {
		"name" : "Noble Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a defense boost (2m).",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(70,40)],
		"achievement" : "Trial By Fire",
	},
	"nomad_statue" : {
		"name" : "Nomad Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a fire rate boost (2m).",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(80,40)],
		"achievement" : "Trial By Fire",
	},
	"scholar_statue" : {
		"name" : "Scholar Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a health regen boost (2m).",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(90,40)],
		"achievement" : "Trial By Fire",
	},
}

var projectiles = {
	"Slash" : {
		"rect" : Rect2(0,0,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"Wave" : {
		"rect" : Rect2(10,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Ball" : {
		"rect" : Rect2(20,0,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"Stack" : {
		"rect" : Rect2(30,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"CannonBall" : {
		"rect" : Rect2(40,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Ring" : {
		"rect" : Rect2(50,0,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"Dart" : {
		"rect" : Rect2(60,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"GoldDart" : {
		"rect" : Rect2(150,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.4,
	},
	"VigilBlast" : {
		"rect" : Rect2(160,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.2,
	},
	"VigilBlastSmall" : {
		"rect" : Rect2(170,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"NeonStar" : {
		"rect" : Rect2(180,0,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1,
	},
	"NeonArrow" : {
		"rect" : Rect2(190,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"Spinner" : {
		"rect" : Rect2(70,0,10,10),
		"rotation" : 45,
		"spin" : true,
	},
	"Star" : {
		"rect" : Rect2(80,0,10,10),
		"rotation" : 45,
		"spin" : true,
	},
	"Blast" : {
		"rect" : Rect2(90,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"GiantBlast" : {
		"rect" : Rect2(90,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.6,
	},
	"SmallBlast" : {
		"rect" : Rect2(100,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"GreenBlast" : {
		"rect" : Rect2(110,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"BrownBlast" : {
		"rect" : Rect2(120,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"BlueBlast" : {
		"rect" : Rect2(130,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"RedBlast" : {
		"rect" : Rect2(140,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"IronSlash" : {
		"rect" : Rect2(0,10,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"GoldSlash" : {
		"rect" : Rect2(10,10,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"PlatinumSlash" : {
		"rect" : Rect2(20,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"MithrilSlash" : {
		"rect" : Rect2(30,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"RexiumSlash" : {
		"rect" : Rect2(40,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"SteelArrow" : {
		"rect" : Rect2(0,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"GoldenArrow" : {
		"rect" : Rect2(10,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"CobaltArrow" : {
		"rect" : Rect2(20,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"BloodArrow" : {
		"rect" : Rect2(30,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.9,
	},
	"RexiumArrow" : {
		"rect" : Rect2(40,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"Nature1" : {
		"rect" : Rect2(0,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Water1" : {
		"rect" : Rect2(10,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Fire1" : {
		"rect" : Rect2(20,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Nature2" : {
		"rect" : Rect2(30,30,10,10),
		"rotation" : 90,
		"spin" : true,
	},
	"Water2" : {
		"rect" : Rect2(40,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Fire2" : {
		"rect" : Rect2(50,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Nature3" : {
		"rect" : Rect2(60,30,10,10),
		"rotation" : 90,
		"spin" : true,
	},
	"Water3" : {
		"rect" : Rect2(70,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Fire3" : {
		"rect" : Rect2(80,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Void1" : {
		"rect" : Rect2(90,30,10,10),
		"rotation" : 90,
		"spin" : true,
	},
}

var achievement_catagories = {
	"Classes" : { 
		"achievements" : ["Trial By Fire"], 
		"icon" : Vector2(0,0)
	},
	"Combat" : { 
		"achievements" : ["Trial By Fire","Trial By Fire","Trial By Fire","Trial By Fire","Trial By Fire","Trial By Fire",], 
		"icon" : Vector2(10,0)
	},
	"Dungeons" : { 
		"achievements" : ["Trial By Fire","Trial By Fire","Trial By Fire","Trial By Fire",], 
		"icon" : Vector2(20,0)
	},
}
var achievements = {
	"Bow Projectiles I" : {
		"which" : "bow_projectiles",
		"amount" : 10,
		"icon" : Vector2(0,10),
		"description" : "Become one with the arrow.",
		"gold" : 0,
		"difficulty" : "easy",
	},
	"Sword Projectiles I" : {
		"which" : "sword_projectiles",
		"amount" : 10,
		"icon" : Vector2(0,0),
		"description" : "Become one with the blaede.",
		"gold" : 0,
		"difficulty" : "easy",
	},
	"Tank I" : {
		"which" : "damage_taken",
		"amount" : 100,
		"icon" : Vector2(0,0),
		"description" : "Take some serious damage.",
		"gold" : 0,
		"difficulty" : "medium",
	},
	"Staff Projectiles I" : {
		"which" : "staff_projectiles",
		"amount" : 10,
		"icon" : Vector2(0,10),
		"description" : "Become one with the magic.",
		"gold" : 0,
		"difficulty" : "easy",
	},
	"Trial By Fire" : {
		"which" : "damage_taken",
		"amount" : 20,
		"icon" : Vector2(0,0),
		"description" : "Take 20 points of damage.",
		"gold" : 400,
		"difficulty" : "hard",
	}
}

var characters = {
	"Apprentice" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
			"Bow Projectiles I" :  "Nomad",
			"Sword Projectiles I" : "Noble",
			"Staff Projectiles I" : "Scholar",
		},
		"rect" : Rect2(0,0,80,40),
		"icon" : Vector2(0,210),
		"color" : Color(196.0/255, 184.0/255, 146.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
				},
				"textures" : {
				},
			}
		},
		"bonus_stats" : {
			"health" : 0,
			"attack" : 0,
			"defense" : 0,
			"speed" : 0,
			"dexterity" : 0,
			"vitality" : 0
		},
		"multipliers" : {
		},
		"description" : "The ultimate jack of all trades, the apprentice is a quick learner who can wield any weapon.",
		"ascension_stones" : 5,
	},
	"Noble" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
			"Tank I" : "Knight",
		},
		"rect" : Rect2(0,40,80,40),
		"icon" : Vector2(20,210),
		"color" : Color(252.0/255, 139.0/255, 14.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(95.0, 83.0, 83.0),
					"helmetLightNew" : RgbToColor(135.0, 117.0, 117.0),
					"helmetMediumNew" : RgbToColor(108.0, 99.0, 99.0),
				},
				"textures" : {
				},
			}
		},
		"bonus_stats" : {
			"health" : 200,
			"attack" : 10,
			"defense" : 20,
			"speed" : 10,
			"dexterity" : 10,
			"vitality" : 20
		},
		"multipliers" : {
			"Sword" : {"damage" : 1.2, "stats" : 1.2},
			"Armor" : {"stats" : 1.2},
			"Helmet" : {"stats" : 1.2},
		},
		"description" : "The Noble's strength and bravery dominate the battlefield.",
		"teaser" : "Discover by becoming one with the blade.",
		"ascension_stones" : 50,
	},
	"Nomad" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(80,80,80,40),
		"icon" : Vector2(10,210),
		"color" : Color(78.0/255, 166.0/255, 63.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"bodyMediumNew" : RgbToColor(14.0, 157.0, 43.0),
					"bodyLightNew" : RgbToColor(25.0, 177.0, 55.0),
					"helmetDarkNew" : RgbToColor(13.0, 128.0, 36.0),
					"helmetMediumNew" : RgbToColor(14.0, 157.0, 43.0),
					"helmetLightNew" : RgbToColor(25.0, 177.0, 55.0),
					"bandNew" : RgbToColor(47.0, 75.0, 29.0),
				},
				"textures" : {
				},
			}
		},
		"bonus_stats" : {
			"health" : 100,
			"attack" : 20,
			"defense" : 10,
			"speed" : 20,
			"dexterity" : 20,
			"vitality" : 10
		},
		"multipliers" : {
			"Bow" : {"rof" : 3, "stats" : 1.2},
			"Leather" : {"stats" : 1.2},
			"Cap" : {"stats" : 1.2},
		},
		"description" : "Swift and precise, the Nomad's arrows strike fear into distant foes.",
		"teaser" : "Discover by becoming one with the arrow.",
		"ascension_stones" : 50,
	},
	"Scholar" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(160,120,80,40),
		"icon" : Vector2(30,210),
		"color" : Color(62.0/255, 118.0/255, 255.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"bodyMediumNew" : RgbToColor(75.0, 13.0, 124.0),
					"bodyLightNew" : RgbToColor(94.0, 23.0, 150.0),
					"helmetDarkNew" : RgbToColor(36.0, 17.0, 131.0),
					"helmetMediumNew" : RgbToColor(94.0, 23.0, 150.0),
					"helmetLightNew" : RgbToColor(122.0, 39.0, 170.0),
					"bandNew" : RgbToColor(33.0, 33.0, 33.0),
				},
				"textures" : {
				},
			}
		},
		"bonus_stats" : {
			"health" : 100,
			"attack" : 30,
			"defense" :0,
			"speed" : 10,
			"dexterity" : 30,
			"vitality" : 10
		},
		"multipliers" : {
			"Staff" : {"damage" : 1.2, "stats" : 1.2},
			"Robe" : {"stats" : 1.2},
			"Hat" : {"stats" : 1.2},
		},
		"description" : "With powerful spells and vast intellect, the Scholar excels at long range.",
		"teaser" : "Discover by becoming one with magic.",
		"ascension_stones" : 50,
	},
	"Knight" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,160,80,40),
		"icon" : Vector2(110,210),
		"color" : Color(232.0/255, 105.0/255, 0.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(95.0, 83.0, 83.0),
					"helmetLightNew" : RgbToColor(135.0, 117.0, 117.0),
					"helmetMediumNew" : RgbToColor(108.0, 99.0, 99.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 100,
			"attack" : 0,
			"defense" : 20,
			"speed" : 0,
			"dexterity" : 0,
			"vitality" : 10,
		},
		"multipliers" : {
			"Sword" : {"damage" : 1.4, "stats" : 1.4},
			"Armor" : {"stats" : 1.4},
			"Helmet" : {"stats" : 1.4},
		},
		"description" : "The Knight's high health and mighty armor make them an unstoppable force.",
		"teaser" : "Discover by enduring the trials of the battlefield.",
		"ascension_stones" : 50,
	},
}

func DegreesToVector(degrees):
	var radians = deg2rad(degrees)
	var vector = Vector2(cos(radians), sin(radians))
	return vector

func RgbToColor(r, g, b):
	r = r*1.0
	g = g*1.0
	b = b*1.0
	return Color(r/255, g/255, b/255)

func GetMultiplier(item):
	var _item = items[int(item)].duplicate(true)
	var result = {}
	
	for type in characters[current_class].multipliers.keys():
		var multipliers = characters[current_class].multipliers[type]
		if _item.type == type:
			for subject in multipliers.keys():
				result[subject] = multipliers[subject]
		
	return result

func GetItem(item, include_class_boost = false):
	if items.has(int(item)) and include_class_boost:
		var _item = items[int(item)].duplicate(true)
		for type in characters[current_class].multipliers.keys():
			var multipliers = characters[current_class].multipliers[type]
			if _item.type == type:
				for subject in multipliers.keys():
					if subject == "damage":
						var index = -1
						for projectile in _item.projectiles:
							index += 1
							_item.projectiles[index][subject][0] = floor(projectile.damage[0]*multipliers[subject])
							_item.projectiles[index][subject][1] = floor(projectile.damage[1]*multipliers[subject])
					elif subject == "stats":
						for stat in _item[subject]:
							_item[subject][stat] = floor(_item[subject][stat]*multipliers[subject])
					else:
						_item[subject] = floor(_item[subject]*multipliers[subject])
		
		return _item
	elif items.has(int(item)):
		return items[int(item)]
	else:
		return null

func GetBuilding(type):
	if buildings.has(type):
		return buildings[type]
	else:
		return null

func GetProjectile(projectile):
	if projectiles.has(projectile):
		return projectiles[projectile]
	else:
		return null

func GetCharacter(character):
	if characters.has(character):
		return characters[character]
	else:
		return null

func GetEnemy(enemy):
	if enemies.has(enemy):
		return enemies[enemy]
	else:
		return null
		
func GetAchievement(achievement):
	if achievements.has(achievement):
		return achievements[achievement]
	else:
		return null
