static var projectile = preload("res://game/projectiles/Vault.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	room.extra_damage += tower.game.money
	tower.fire_projectiles(room, projectile, 1)
