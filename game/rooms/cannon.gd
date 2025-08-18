extends "res://game/room.gd"

var projectile = load("res://game/rooms/CannonProjectile.tscn")

func _on_trigger() -> void:
	self.fire_projectiles(projectile, 1)
