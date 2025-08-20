static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	var buff_rooms: Array[Tower.RoomInstance] = tower.get_adjacent_rooms(room).values()
	for target_room in buff_rooms:
		pass
	#TODO actually implement this one
