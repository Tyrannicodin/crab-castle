static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	room.play_sound(tower, "buff")
	
	var buff_room: Tower.RoomInstance = (tower
		.get_adjacent_rooms(room)
		.values()
		.filter(func(value): return not not value)
		.pick_random()
	)
	buff_room.music_room_cooldown_reduction += .1
	buff_room.create_flavor_text(tower, "-.1s Cooldown")
