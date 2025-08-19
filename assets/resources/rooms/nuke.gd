static var projectile = preload("res://game/projectiles/Nuke.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	room.bonus_projectiles = 0
	tower.fire_projectiles(room, projectile, 1)
