static var projectile = preload("res://game/projectiles/Shuriken.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	room.play_sound(tower, "buff")
	tower.game.tower_health += 2
	room.create_flavor_text(tower, "+2 Health")
