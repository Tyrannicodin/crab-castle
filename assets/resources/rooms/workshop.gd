static var projectile = preload("res://game/projectiles/Cannon.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	tower.game.money += 2
	room.play_sound(tower, "buff")
	room.create_flavor_text(tower, "+2 Coins")
