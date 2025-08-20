static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	var buff_rooms: Array[Tower.RoomInstance] = tower.get_adjacent_rooms(room).values()
	for target_room in buff_rooms:
		if target_room == null: continue
		target_room.extra_damage += 3
