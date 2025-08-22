static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	room.play_sound(tower, "buff")
	
	for r: Tower.RoomInstance in tower.get_adjacent_rooms(room).values():
		r.music_room_cooldown_reduction += .1
		room.create_flavor_text(tower, "-.1s Cooldown")
