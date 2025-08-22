static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	var buff_rooms: Array[Tower.RoomInstance] = tower.get_adjacent_rooms(room).values()
	room.play_sound(tower, "buff")
	for target_room in buff_rooms:
		if target_room == null: continue
		await tower.get_tree().create_timer(.2).timeout
		target_room.extra_damage += 6
		target_room.create_flavor_text(tower, "+6 Damage")
