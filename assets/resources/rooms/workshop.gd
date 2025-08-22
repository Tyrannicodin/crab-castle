static var projectile = preload("res://game/projectiles/Cannon.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	room.workshop_extra_coins += .2
	tower.game.money += floor(room.workshop_extra_coins)
	room.play_sound(tower, "buff")
	room.create_flavor_text(tower, "+%d Coins" % floor(room.workshop_extra_coins))
