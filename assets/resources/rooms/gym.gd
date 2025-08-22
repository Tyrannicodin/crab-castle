static var projectile = preload("res://game/projectiles/Gym.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:	
	room.gym_extra_damage += .1
	room.extra_damage += floor(room.gym_extra_damage)
	tower.fire_projectiles(room, projectile, 1)
