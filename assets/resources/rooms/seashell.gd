static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	var buff_rooms: Array[Tower.RoomInstance] = tower.get_adjacent_rooms(room).values()
	room.play_sound(tower, "buff")
	for target_room in buff_rooms:
		if target_room:
			target_room.bonus_projectiles += 1
			target_room.create_flavor_text(tower, "+1 Projectile")
