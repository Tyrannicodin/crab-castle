extends "res://game/room.gd"

var projectile = load("res://game/rooms/CannonProjectile.tscn")

func _on_trigger() -> void:
	var target = game.find_closest_enemy(self)
	
	if target:
		var projectile = projectile.instantiate()
		self.game.add_child(projectile)
		game.fire_projectile_from_room(projectile, target)
