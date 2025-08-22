static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	var closest_target = tower.game.find_closest_enemy(room).global_position
	var room_pos = tower.get_room_global_position(room)

	if room_pos.distance_to(closest_target) > 350:
		return
	
	for enemy in tower.game.find_closest_enemies(room):
		if room_pos.distance_to(enemy.global_position) > 600:
			return
		
		enemy.damage(200)
		enemy.stun_lock(3)
		enemy.knockback(10)
	
	var overlay = tower.room_overlays[room.position]
	tower.room_overlays.erase(room.position)
	tower.rooms = tower.rooms.filter(
		func(room_candidate: Tower.RoomInstance):
			return room.position != room_candidate.position
	)
	overlay.queue_free()
	tower.redraw_castle()
