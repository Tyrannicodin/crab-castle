extends "res://game/room.gd"

var projectile = load("res://game/rooms/SlingshotProjectile.tscn")

func _on_trigger() -> void:
	var target = game.find_closest_enemy(self)
	
	if target:
		var projectileInst = projectile.instantiate()
		self.game.add_child(projectileInst)
		game.fire_projectile_from_room(self, projectileInst, target)
