extends Node

static var Seagull = preload("res://assets/resources/enemies/seagull.tres")
static var Fish = preload("res://assets/resources/enemies/fish.tres")
static var Shark = preload("res://assets/resources/enemies/shark.tres")
static var Octopus = preload("res://assets/resources/enemies/octopus.tres")
static var PlaneEnemy = preload("res://assets/resources/enemies/plane.tres")
static var CrazyBird = preload("res://assets/resources/enemies/crazy-bird.tres")
static var Alligator = preload("res://assets/resources/enemies/aliigator_missle.tres")


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
			[PlaneEnemy],
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
	# Wave 10
	func() : 
		return {
		"water_level": 3,
		"enemies": [
			[CrazyBird],
			range(6).map(func(_i): return [Octopus, 1]) + range(5).map(func(_i): return CrazyBird),
			range(10).map(func(_i): return [Seagull, 1]) + [Shark, Shark],
			[[Shark, 1]]
		]
	},
	# Wave 11
	func() : 
		return {
		"water_level": 4,
		"enemies": [
			range(2).map(func(_i): return Alligator),
			range(2).map(func(_i): return Shark) + range(5).map(func(_i): return [Fish, 1]) + range(2).map(func(_i): return CrazyBird),
			range(2).map(func(_i): return [Shark, 1]) + [Shark, Shark] + range(4).map(func(_i): return CrazyBird),
		]
	},
	# Wave 12
	func() : 
		return {
		"water_level": 3,
		"enemies": [
			range(4).map(func(_i): return PlaneEnemy) + range(10).map(func(_i): return [Fish, 2]),
			range(2).map(func(_i): return [Shark, 1]) + [Shark, Shark],
			[[Shark, 2]]
		]
	},
	# Wave 13
	func() : 
		return {
		"water_level": 2,
		"enemies": [
			range(10).map(func(_i): return [CrazyBird, 1]) + range(5).map(func(_i): return [CrazyBird, 2]),
			range(10).map(func(_i): return [Octopus, 1]) + [Shark, Shark, Shark, Shark, Shark],
			[[PlaneEnemy, 2]]
		]
	},
	# Wave 14
	func() : 
		return {
		"water_level": 1,
		"enemies": [
			[[Shark, 2], [Octopus, 2], [Octopus, 2]],
			range(6).map(func(_i): return [CrazyBird, 1]) + range(12).map(func(_i): return [Seagull, 3]),
			[[Shark, 3]],
		]
	},
	# Wave 15
	func() : 
		return {
		"water_level": 2,
		"enemies": [
			range(20).map(func(_i): return Fish) + range(20).map(func(_i): return [Fish, 1]),
			range(20).map(func(_i): return [Fish, 1]) + range(10).map(func(_i): return [Fish, 2]),
			range(15).map(func(_i): return [Fish, 1]) + range(10).map(func(_i): return [Fish, 3]),
		]
	},
	# Wave 16
	func() : 
		return {
		"water_level": 3,
		"enemies": [
			[[Shark, 3]] + range(15).map(func(_i): return [Fish, 1]) + range(10).map(func(_i): return [Fish, 3]),
			range(10).map(func(_i): return [Octopus, 2]) + range(10).map(func(_i): return [CrazyBird, 2])
		]
	},
	# Wave 17
	func() : 
		return {
		"water_level": 3,
		"enemies": [
			[[PlaneEnemy, 3]],
			range(10).map(func(_i): return [Octopus, 2])
		]
	},
	# Wave 18
	func() : 
		return {
		"water_level": 4,
		"enemies": [
			[[PlaneEnemy, 3], [PlaneEnemy, 2], [PlaneEnemy, 2]],
			range(10).map(func(_i): return [Octopus, 2]) + range(15).map(func(_i): return [Octopus, 3])
		]
	},
	# Wave 19
	func() : 
		return {
		"water_level": 2,
		"enemies": [
			range(2).map(func(_i): return [CrazyBird, 3]) + range(8).map(func(_i): return [CrazyBird, 1]),
			range(6).map(func(_i): return [CrazyBird, 2]),
			range(3).map(func(_i): return [CrazyBird, 1]) + range(4).map(func(_i): return [CrazyBird, 3])
		]
	},
	# Wave 20
	func() : 
		return {
		"water_level": 5,
		"enemies": [
			[[Shark, 3],[Shark, 3],[Shark, 3],[Shark, 3],[Shark, 3]]
		]
	},
]
