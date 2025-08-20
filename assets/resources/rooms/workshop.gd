static var projectile = preload("res://game/projectiles/Cannon.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	tower.game.money += 2
