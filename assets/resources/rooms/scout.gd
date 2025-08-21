static var projectile = preload("res://game/projectiles/Scout.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	room.extra_damage += 10 * (5 - room.position.y)
	tower.fire_projectiles(room, projectile, 1)
