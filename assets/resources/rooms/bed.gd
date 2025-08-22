static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	var buff_rooms: Array[Tower.RoomInstance] = tower.get_adjacent_rooms(room).values()
	room.play_sound(tower, "buff")
	for target_room in buff_rooms:
		if target_room:
			if target_room.cooldown <= 1.0:
				var extra_projectiles = floor(1.0 / target_room.cooldown)
				target_room.bonus_projectiles += floor(1.0 / target_room.cooldown)
				target_room.cooldown_remaining = target_room.cooldown_remaining + (1/target_room.cooldown) - extra_projectiles
			else:
				target_room.cooldown_remaining -= 1.0
				if target_room.cooldown_remaining <= 0:
					target_room.cooldown_remaining = target_room.cooldown + target_room.cooldown_remaining
					target_room.trigger(tower)
			target_room.create_flavor_text(tower, "-1s Cooldown")
