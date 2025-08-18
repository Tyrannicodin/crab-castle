extends "res://game/room.gd"

var projectile = load("res://game/rooms/SlingshotProjectile.tscn")

func _on_trigger() -> void:
	self.fire_projectiles(projectile, 3)
