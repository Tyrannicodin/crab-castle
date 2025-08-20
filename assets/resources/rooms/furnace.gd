static var projectile = preload("res://game/projectiles/Fire.tscn")

static func can_fire(game: Game, tower: Tower, room: Tower.RoomInstance):
	return len(game.find_closest_enemies(room, func(e: EnemyInstance): return e.underwater == false)) > 0

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	tower.fire_projectiles(room, projectile, 1, func(e: EnemyInstance): return e.underwater == false)
