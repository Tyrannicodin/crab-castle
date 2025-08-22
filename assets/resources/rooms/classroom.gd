static var projectile = preload("res://game/projectiles/Classroom.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	var unique_rooms = {}
	
	for r in tower.rooms:
		unique_rooms[r.type.display_name] = null
	
	tower.fire_projectiles(room, projectile, 1 + len(unique_rooms.keys()))
