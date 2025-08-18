extends "res://game/room.gd"

var projectile = load("res://game/rooms/FreezerProjectile.tscn")

func _on_trigger() -> void:
	fire_projectiles_above_enemy(projectile, 1)
