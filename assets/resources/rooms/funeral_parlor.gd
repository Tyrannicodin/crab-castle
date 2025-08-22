static var projectile = preload("res://game/projectiles/Cannon.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	var lives_remaining = tower.game.tower_health
	var scaling = room.funeral_parlor_scaling

	if scaling > lives_remaining:
		scaling = (lives_remaining - 1)

	tower.game.tower_health -= scaling
	room.create_flavor_text(tower, "-%d Health" % scaling)

	for r: Tower.RoomInstance in tower.get_adjacent_rooms(room).values():
		if r == null: continue
		await tower.get_tree().create_timer(.2).timeout
		r.funeral_parlor_extra_damage += scaling
		r.create_flavor_text(tower, "+%d Damage" % scaling)

	room.funeral_parlor_scaling += 1
