extends "res://game/room.gd"


func _on_trigger() -> void:
	var target = game.find_closest_enemy(self)
	
	if target:
		var projectile = load("res://game/rooms/CannonProjectile.tscn").instantiate()
		self.game.add_child(projectile)
		game.fire_projectile_from_room(projectile, target)
