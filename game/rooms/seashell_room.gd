extends "res://game/room.gd"


func _on_trigger() -> void:
	var buff_rooms: Array[Room] = game.find_adjacent_rooms(self).values()

	for room in buff_rooms:
		if room:
			room.extra_projectiles_for_next_shot += 1
