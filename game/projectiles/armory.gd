extends "res://game/projectiles/projectile.gd"

func _ready() -> void:
	var swords: Array = [
		[$Sword1, 15, 2],
		[$Sword2, 10, 2],
		[$Sword3, 8, 1],
		[$Sword4, 5, 1],
		[$Sword5, 20, 3],
	]
	
	var this_sword = swords.pick_random()

	this_sword[0].show()
	damage = this_sword[1]
	pierce = this_sword[2]
