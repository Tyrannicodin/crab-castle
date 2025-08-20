static var projectile = preload("res://game/projectiles/Freezer.tscn")

static func can_fire(game: Game, tower: Tower, room: Tower.RoomInstance):
	return len(game.find_closest_enemies(room, func(e: EnemyInstance): return e.underwater == true)) > 0

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	tower.fire_projectiles_above_enemy(room, projectile, 1, func(e: EnemyInstance): return e.underwater == true)
