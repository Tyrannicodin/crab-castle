static var projectile = preload("res://game/projectiles/Cannon.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	var rooms = tower.get_adjacent_rooms(room).values()

	room.play_sound(tower, "buff")

	for r in rooms:
		if r == null: continue
		await tower.get_tree().create_timer(.2).timeout
		r.extra_pierce += 3
		r.create_flavor_text(tower, "+3 Pierce")
