static var projectile = preload("res://game/projectiles/Cannon.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	var lives_remaining = tower.game.tower_health
	var scaling = room.funeral_parlor_scaling

	if scaling > lives_remaining:
		scaling = (lives_remaining - 1)

	tower.game.tower_health -= scaling
	room.create_flavor_text(tower, "-%d Health" % scaling)

	var rooms = tower.rooms.duplicate()
	rooms = rooms.filter(func(r: Tower.RoomInstance): return r.type.display_name != "Funeral Parlor")

	await tower.get_tree().create_timer(.2).timeout
	rooms[0].funeral_parlor_extra_damage += scaling
	rooms[0].create_flavor_text(tower, "+%d Damage" % scaling)

	room.funeral_parlor_scaling += 1

	room.play_sound(tower, "buff")
