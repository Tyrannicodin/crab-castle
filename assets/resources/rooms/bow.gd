static var projectile = preload("res://game/projectiles/Bow.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	tower.fire_projectiles(room, projectile, 1)
