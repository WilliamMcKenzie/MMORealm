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
		"loot" : [
			{
				"item" : 100,
				"chance" : 0.05,
			},
			{
				"item" : 400,
				"chance" : 0.05,
			},
			{
				"item" : 500,
				"chance" : 0.05,
			},
		]
	},
	"lowlands_2" : {
		"soulbound_loot" : [],
		"loot" : [
			{
				"item" : 100,
				"chance" : 0.15,
			},
			{
				"item" : 400,
				"chance" : 0.15,
			},
			{
				"item" : 500,
				"chance" : 0.15,
			},
		]
	},
	"midlands_1" : {
		"soulbound_loot" : [],
		"loot" : [
			{
				"item" : 101,
				"chance" : 0.05,
			},
			{
				"item" : 401,
				"chance" : 0.05,
			},
			{
				"item" : 501,
				"chance" : 0.05,
			},
		]
	},
	"midlands_2" : {
		"soulbound_loot" : [],
		"loot" : [
			{
				"item" : 101,
				"chance" : 0.2,
			},
			{
				"item" : 401,
				"chance" : 0.2,
			},
			{
				"item" : 501,
				"chance" : 0.2,
			},
		]
	},
	"highlands_1" : {
		"soulbound_loot" : [],
		"loot" : [
			{
				"item" : 101,
				"chance" : 0.03,
			},
			{
				"item" : 401,
				"chance" : 0.03,
			},
			{
				"item" : 501,
				"chance" : 0.03,
			},
		]
	},
	"highlands_2" : {
		"soulbound_loot" : [
				{
					"item" : 102,
					"chance" : 0.1,
					"threshold" : 0.2,
				},
				{
					"item" : 402,
					"chance" : 0.1,
					"threshold" : 0.2,
				},
				{
					"item" : 502,
					"chance" : 0.1,
					"threshold" : 0.2,
				}
		],
		"loot" : []
	},
	"godlands_1" : {
		"soulbound_loot" : [
				{
					"item" : 103,
					"chance" : 0.05,
					"threshold" : 0.2,
				},
				{
					"item" : 403,
					"chance" : 0.05,
					"threshold" : 0.2,
				},
				{
					"item" : 503,
					"chance" : 0.05,
					"threshold" : 0.2,
				},
				{
					"item" : 102,
					"chance" : 0.1,
					"threshold" : 0.2,
				},
				{
					"item" : 402,
					"chance" : 0.1,
					"threshold" : 0.2,
				},
				{
					"item" : 502,
					"chance" : 0.1,
					"threshold" : 0.2,
				},
				{
					"item" : 0,
					"chance" : 0.01,
					"threshold" : 0.2,
				}
		],
		"loot" : []
	},
}

var rulers = {
	"oranix" : {
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
	"salazar_the_red" : {
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
		"exp" : 10,
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
				"duration" : 4,
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
						"wait" : 5,
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
		"speed" : 6,
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
		"behavior" : 1,
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
						"wait" : 600000,
					},
				]
			},
		]
	},
	"blue_slime" : {
		"health" : 400,
		"defense" : 1,
		"exp" : 12,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 5,
						"piercing" : true,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
					{
						"projectile" : "Water1",
						"formula" : "0",
						"damage" : 5,
						"piercing" : true,
						"wait" : 3,
						"speed" : 8,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 3
					}
				]
			}
		]
	},
	"troll_warrior" : {
		"variations" : ["tutorial_troll_warrior"],
		"health" : 300,
		"defense" : 1,
		"exp" : 6,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" :  basic_loot_pools["midlands_1"],
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
		"health" : 400,
		"defense" : 10,
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
		"health" : 700,
		"defense" : 10,
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
		"health" : 500,
		"defense" : 6,
		"exp" : 24,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" :  basic_loot_pools["highlands_1"],
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
		"health" : 1000,
		"defense" : 4,
		"exp" : 200,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["highlands_2"],
		"phases" : [
			{
				"duration" : 2,
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
						"summon" : "rat_warrior",
						"summon_position" : Vector2(10,0),
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
						"wait" : 6000,
					},
				]
			},
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 7,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 7
					}
				]
			},
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : Vector2(2,0),
						"size" : 5
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 3,
						"speed" : 10,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : Vector2(-2,0),
						"size" : 5
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
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 5,
						"direction" : Vector2(0,1),
						"size" : 4
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 5,
						"direction" : Vector2(1,0),
						"size" : 4
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 5,
						"direction" : Vector2(0,-1),
						"size" : 4
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 5,
						"direction" : Vector2(-1,0),
						"size" : 4
					}
				]
			},
			{
				"duration" : 6,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Spinner",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 7,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					},
					{
						"projectile" : "Star",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 3,
						"speed" : 7,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : Vector2(10,0),
						"size" : 4
					},
				]
			}
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
						"wait" : 3,
						"speed" : 20,
						"tile_range" : 2,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					},
				]
			}
		]
	},
	"yellow_slime" : {
		"health" : 350,
		"defense" : 0,
		"exp" : 62,
		"behavior" : 1,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0.5,
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
						"piercing" : false,
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
	"rock_golem" : {
		"health" : 1500,
		"defense" : 25,
		"exp" : 200,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 3,
						"speed" : 20,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 8
					}
				]
			}
		]
	},
	"mummified_ghoul" : {
		"health" : 1500,
		"defense" : 25,
		"exp" : 200,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 3,
						"speed" : 20,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 8
					}
				]
			}
		]
	},
	"shadow_spider" : {
		"health" : 1500,
		"defense" : 25,
		"exp" : 200,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 3,
						"speed" : 20,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 8
					}
				]
			}
		]
	},
	"slime_god" : {
		"health" : 1500,
		"defense" : 25,
		"exp" : 200,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 3,
						"speed" : 20,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 8
					}
				]
			}
		]
	},
}
var overgrown_temple_enemies = {
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
		"tier" : "1",
		
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
		"tier" : "2",
		
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
		"name": "Running real fast robes",
		"description" : "A testers first line of defense",
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
		"scale" : 0.8,
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
		"scale" : 0.8,
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
		"scale" : 0.8,
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
