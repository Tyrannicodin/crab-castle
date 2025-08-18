static var projectile = preload("res://game/projectiles/Freezer.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	tower.fire_projectiles_above_enemy(room, projectile, 1)
