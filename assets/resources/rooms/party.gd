static var projectile = preload("res://game/projectiles/Cannon.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	var rooms = tower.rooms.duplicate()
	rooms.shuffle()
	rooms = rooms.filter(func(r: Tower.RoomInstance): return r.type.display_name != "Ballroom")
	rooms = rooms.slice(0,3)
	
	await tower.get_tree().create_timer(.2).timeout
	
	for r in rooms:
		r.trigger(tower)
		await tower.get_tree().create_timer(.2).timeout
