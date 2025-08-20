static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	tower.game.money += 1
	room.create_flavor_text(tower, "+2 Coins")
