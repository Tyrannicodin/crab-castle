static var projectile = preload("res://game/projectiles/Cannon.tscn")

static func on_trigger(tower: Tower, room: Tower.RoomInstance) -> void:
	room.play_sound(tower, "buff")

	var extra_damage = room.extra_damage * 2
	var extra_pierce = room.extra_pierce * 2
	var extra_projectile = room.bonus_projectiles * 2
	
	room.extra_damage = 0
	room.extra_pierce = 0
	room.bonus_projectiles = 0

	for r: Tower.RoomInstance in tower.get_adjacent_rooms(room).values():
		if r == null: continue
		if r.type.display_name == "Stairwell": continue
		
		if extra_damage != 0:
			r.extra_damage += extra_damage
			r.create_flavor_text(tower, "+%d Damage" % extra_damage)
		if extra_pierce != 0:
			r.extra_pierce += extra_pierce
			r.create_flavor_text(tower, "+%d Pierce" % extra_pierce)
		if extra_projectile != 0:
			r.bonus_projectiles += extra_projectile
			# will never be 1, dont need to handle singular tense
			r.create_flavor_text(tower, "+%d Projectiles" % extra_projectile)

		await tower.get_tree().create_timer(.2).timeout
