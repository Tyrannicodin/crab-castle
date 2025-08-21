extends Node

static var Seagull = preload("res://assets/resources/enemies/seagull.tres")
static var Fish = preload("res://assets/resources/enemies/fish.tres")
static var Shark = preload("res://assets/resources/enemies/shark.tres")
static var Octopus = preload("res://assets/resources/enemies/octopus.tres")
static var PlaneEnemy = preload("res://assets/resources/enemies/plane.tres")


static var waves = [
	# Wave 1
	func(): return {
		"water_level": 0,	
		"enemies": [
			[Seagull]
		]
	},
	# Wave 2
	func(): return {
		"water_level": 1,
		"enemies": [
			[Seagull, Seagull],
			[Seagull, Seagull],
		]
	},
	# Wave 3
	func() : return {
		"water_level": 2,
		"enemies": [
			[Octopus],
			[Octopus, Octopus, Seagull, Seagull],
		]
	},
	# Wave 4
	func() : return {
		"water_level": 3,
		"enemies": [
			[Seagull, Seagull, Seagull, Seagull],
			[Octopus, Octopus, Octopus, Octopus],
		]
	},
	# Wave 5
	func() : return {
		"water_level": 4,
		"enemies": [
			[Octopus, Octopus, Octopus, Octopus],
			[Octopus, Octopus, Octopus, Seagull, Seagull, Seagull],
			[Shark]
		]
	},
	# Wave 6
	func() : return {
		"water_level": 3,
		"enemies": [
			[Fish],
			[Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish],
			[Octopus, Octopus, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish]
		]
	},
	# Wave 7
	func() : return {
		"water_level": 2,
		"enemies": [
			[Fish, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Seagull, Seagull, Seagull, Seagull],
			[Fish, Fish, Fish, Fish, Fish, Fish, Octopus, Octopus, Seagull, Seagull, Seagull, Seagull],
			[Octopus, Octopus, Fish, Fish, Fish, Fish, Fish, Fish, Fish, Shark]
		]
	},
	# Wave 8
	func() : return {
		"water_level": 1,
		"enemies": [
			[PlaneEnemy],
			[[Seagull, 1],[Seagull, 1],[Seagull, 1],[Seagull, 1],Seagull, Seagull, Seagull,Seagull, Seagull, Seagull],
			[PlaneEnemy, PlaneEnemy],
		]
	},
	# Wave 9
	func() : 
		var second = range(7).map(func(_i): return [Fish, 1]) + range(7).map(func(_i): return [Seagull, 1])
		return {
		"water_level": 2,
		"enemies": [
			range(10).map(func(_i): return [Fish, 1]),
			second,
			[PlaneEnemy, PlaneEnemy, Shark, Shark]
		]
	},
]
