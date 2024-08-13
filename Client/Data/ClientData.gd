extends Node

var current_class = "Apprentice"

#Tile data
var unique_tiles = {
	0 : 0.01,
	1 : 0.5,
}

var basic_loot_pools = {
	"lowlands_1" : {
		"soulbound_loot" : [
			{
				"item" : 2,
				"chance" : 0.15,
				"threshold" : 0.15,
			},
			{
				"item" : 5,
				"chance" : 0.23,
				"threshold" : 0.23,
			},
			{
				"item" : 0,
				"chance" : 0.3,
				"threshold" : 0.3,
			}
		],
		"loot" : [
			{
				"item" : 1,
				"chance" : 0.25,
			}
		]
	},
	"lowlands_2" : {
		"soulbound_loot" : [
				{
					"item" : 5,
					"chance" : 0.23,
					"threshold" : 0.23,
				},
				{
					"item" : 2,
					"chance" : 0.5,
					"threshold" : 0.15,
				},
			{
				"item" : 0,
				"chance" : 0.1,
				"threshold" : 0.5,
			}
		],
		"loot" : [
			{
				"item" : 1,
				"chance" : 0.25,
			}
		]
	}
}

var rulers = {
	"crypt_guardian" : {
		"health" : 200,
		"defense" : 30,
		"exp" : 4000,
		"behavior" : 1,
		"speed" : 10,
		"dungeon" : {
			"name" : "overgrown_temple",
			"rate" : 0
		},
		"loot_pool" :  {
			"soulbound_loot" : [],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 10,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Dart",
						"formula" : "sin(x)",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					},
					{
						"projectile" : "Dart",
						"formula" : "sin(x)",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(10,0),
						"size" : 5
					},
					{
						"projectile" : "Dart",
						"formula" : "sin(x)",
						"damage" : 100,
						"piercing" : false,
						"wait" : 4,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(-10,0),
						"size" : 5
					},
				]
			},
			{
				"duration" : 7,
				"max_uses" : 1,
				"health" : [50,100],
				"behavior" : 2,
				"attack_pattern" : [
					{
						"summon" : "crypt_guardian_summon",
						"summon_position" : Vector2(0,0),
						"wait" : 1,
					},
					{
						"projectile" : "Spinner",
						"formula" : "sin(x)",
						"damage" : 200,
						"piercing" : false,
						"wait" : 1,
						"speed" : 20,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					},
					{
						"projectile" : "Spinner",
						"formula" : "sin(x)",
						"damage" : 200,
						"piercing" : false,
						"wait" : 1,
						"speed" : 20,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					},
					{
						"summon" : "crypt_guardian_summon",
						"summon_position" : Vector2(0,0),
						"wait" : 1,
					},
					{
						"projectile" : "Spinner",
						"formula" : "sin(x)",
						"damage" : 200,
						"piercing" : false,
						"wait" : 1,
						"speed" : 20,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					},
					{
						"projectile" : "Spinner",
						"formula" : "sin(x)",
						"damage" : 200,
						"piercing" : false,
						"wait" : 1,
						"speed" : 20,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					},
					{
						"summon" : "crypt_guardian_summon",
						"summon_position" : Vector2(0,0),
						"wait" : 1,
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
						"size" : 5
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
						"size" : 5
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
						"size" : 5
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(0,-1),
						"size" : 5
					},
				]
			}
		]
	},
	"crypt_guardian_summon" : {
		"health" : 100,
		"defense" : 20,
		"exp" : 2000,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" :  {
			"soulbound_loot" : [],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 50,
						"tile_range" : 1,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					}
				]
			}
		]
	}
}
var tutorial_enemies = {
	"tutorial_crab" : {
		"health" : 20,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : {
			"soulbound_loot" : [
				{
					"item" : 5,
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
						"damage" : 20,
						"piercing" : true,
						"wait" : 10,
						"speed" : 10,
						"tile_range" : 8,
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
		"exp" : 200,
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
	"tutorial_troll_king" : {
		"health" : 300,
		"defense" : 10,
		"exp" : 200,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  {
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
				"health" : [50,100],
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
				"health" : [0,50],
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
		"health" : 60,
		"defense" : 1,
		"exp" : 20,
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
						"damage" : 10,
						"piercing" : false,
						"wait" : 3,
						"speed" : 10,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					},
				]
			}
		]
	},
	"slime" : {
		"health" : 60,
		"defense" : 1,
		"exp" : 30,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 3,
						"speed" : 10,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					}
				]
			}
		]
	},
	"nature_druid" : {
		"health" : 200,
		"defense" : 3,
		"exp" : 250,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Nature2",
						"formula" : "sin(x)",
						"damage" : 20,
						"piercing" : false,
						"wait" : 1,
						"speed" : 30,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					}
				]
			},
			{
				"duration" : 4,
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
						"wait" : 5,
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
						"damage" : 20,
						"piercing" : false,
						"wait" : 1,
						"speed" : 30,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					}
				]
			},
		]
	},
	"nature_sprite" : {
		"health" : 10,
		"defense" : 0,
		"exp" : 20,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["lowlands_1"],
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
						"direction" : Vector2(0,0),
						"size" : 4
					}
				]
			}
		]
	},
	"goblin_warrior" : {
		"health" : 60,
		"defense" : 3,
		"exp" : 40,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "SteelSlash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 5,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					}
				]
			}
		]
	},
	"goblin_cannon" : {
		"health" : 20,
		"defense" : 1000,
		"exp" : 250,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 7,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "CannonBall",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 8,
						"speed" : 6,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 5
					}
				]
			},
			{
				"duration" : 2,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "goblin_warrior",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "goblin_archer",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "goblin_warrior",
						"summon_position" : Vector2(-10,5),
						"wait" : 600000,
					},
				]
			},
		]
	},
	"blue_slime" : {
		"health" : 120,
		"defense" : 1,
		"exp" : 30,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 20,
						"piercing" : true,
						"wait" : 3,
						"speed" : 10,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					},
					{
						"projectile" : "Water1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : true,
						"wait" : 3,
						"speed" : 8,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 3
					}
				]
			}
		]
	},
	"troll_warrior" : {
		"variations" : ["tutorial_troll_warrior"],
		"health" : 100,
		"defense" : 1,
		"exp" : 300,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
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
		"health" : 300,
		"defense" : 10,
		"exp" : 450,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
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
						"wait" : 1,
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
		"health" : 700,
		"defense" : 10,
		"exp" : 1000,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" :  {
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
				"max_uses" : 1,
				"health" : [0,50],
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
		"health" : 500,
		"defense" : 20,
		"exp" : 1000,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["lowlands_1"],
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
						"wait" : 3,
						"speed" : 10,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					},
				]
			}
		]
	},
	"rat_mage" : {
		"health" : 250,
		"defense" : 10,
		"exp" : 1000,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 3,
						"speed" : 10,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					},
				]
			}
		]
	},
	"rat_king" : {
		"health" : 100,
		"defense" : 100,
		"exp" : 3000,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10000,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "rat_warrior",
						"summon_position" : Vector2(-10,0),
						"wait" : 1,
					},
					{
						"summon" : "rat_warrior",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "rat_mage",
						"summon_position" : Vector2(0,0),
						"wait" : 6000,
					},
				]
			}
		]
	},
	"viking_king" : {
		"health" : 3000,
		"defense" : 0,
		"exp" : 3000,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10000,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "viking_warrior",
						"summon_position" : Vector2(-10,0),
						"wait" : 1,
					},
					{
						"summon" : "viking_warrior",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "viking_warrior",
						"summon_position" : Vector2(0,0),
						"wait" : 6000,
					},
				]
			}
		]
	},
	"viking_warrior" : {
		"health" : 500,
		"defense" : 0,
		"exp" : 500,
		"behavior" : 2,
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
						"damage" : 10,
						"piercing" : false,
						"wait" : 3,
						"speed" : 10,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					},
				]
			}
		]
	},
	"yellow_slime" : {
		"health" : 3000,
		"defense" : -100,
		"exp" : 2000,
		"behavior" : 1,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 20,
						"piercing" : true,
						"wait" : 3,
						"speed" : 10,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : true,
						"wait" : 3,
						"speed" : 8,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 3
					}
				]
			}
		]
	},
}
var overgrown_temple_enemies = {
	"shadow_mage" : {
		"health" : 200,
		"defense" : 1,
		"exp" : 20,
		"behavior" : 1,
		"speed" : 20,
		"loot_pool" :  basic_loot_pools["lowlands_2"],
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
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 20
					}
				]
			}
		]
	},
}
var enemies = CompileEnemies()
func CompileEnemies():
	var res = {}
	res.merge(rulers)
	res.merge(tutorial_enemies)
	res.merge(realm_enemies)
	res.merge(overgrown_temple_enemies)
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
	1 : {
		"name": "Short Sword",
		"description" : "A simple yet effective weapon.",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "0",
		
		"damage" : [15,25],
		"rof" : 100,
		"stats" : {},
		
		"projectile" : "Slash",
		"formula" : "0",
		"piercing" : false,
		"speed" : 50,
		"tile_range" : 3,
		"size" : 4,
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(105.0, 51.0, 10.0),
			"weaponNew" : RgbToColor(174.0, 172.0, 156.0)
		},
		"textures" : {}
	},
	2 : {
		"name": "Void Armor",
		"description" : "A soldiers first line of defense.",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "5",
		
		"stats" : {
			"speed" : 100
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(0.0, 106.0, 138.0),
			"bodyLightNew" : RgbToColor(0.0, 125.0, 163.0),
			"bandNew" : RgbToColor(225.0, 179.0, 36.0),
		},
		"textures" : {
			
		}
	},
		3 : {
		"name": "Steel Helmet",
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
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(213.0, 190.0, 65.0),
			"helmetMediumNew" : RgbToColor(139.0, 129.0, 125.0),
			"helmetDarkNew" : RgbToColor(126.0, 118.0, 115.0),
		},
		"textures" : {
			
		}
	},
		4 : {
		"name": "Steel Helmet",
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
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(213.0, 190.0, 65.0),
			"helmetMediumNew" : RgbToColor(139.0, 129.0, 125.0),
			"helmetDarkNew" : RgbToColor(126.0, 118.0, 115.0),
		},
		"textures" : {
			
		}
	},
	5 : {
		"name": "Steel Helmet",
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
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(213.0, 190.0, 65.0),
			"helmetMediumNew" : RgbToColor(139.0, 129.0, 125.0),
			"helmetDarkNew" : RgbToColor(126.0, 118.0, 115.0),
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
		"path" : ["tiles/tileset.png", 26, 26, Vector2(80,0)],
		"tile" : 3,
	},
	"wooden_planks" : {
		"name" : "Wooden Planks",
		"type" : "tile",
		"description" : "Straight from the docks.",
		
		"craftable" : true,
		"materials" : [0,0,0],
		"max" : 20,
		"path" : ["tiles/tileset.png", 26, 26, Vector2(170,20)],
		"tile" : 10,
	},
	"knight_statue" : {
		"name" : "Knight Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a defense boost (2m).",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(60,40)],
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
	"SteelSlash" : {
		"rect" : Rect2(0,10,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"GoldenSlash" : {
		"rect" : Rect2(10,10,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"PlatinumSlash" : {
		"rect" : Rect2(20,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"CobaltSlash" : {
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
	},
	"GoldenArrow" : {
		"rect" : Rect2(10,20,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"CobaltArrow" : {
		"rect" : Rect2(20,20,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"BloodArrow" : {
		"rect" : Rect2(30,20,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"RexiumArrow" : {
		"rect" : Rect2(40,20,10,10),
		"rotation" : 45,
		"spin" : false,
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
						_item[subject][0] = floor(_item[subject][0]*multipliers[subject])
						_item[subject][1] = floor(_item[subject][1]*multipliers[subject])
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
