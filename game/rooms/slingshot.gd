extends "res://game/room.gd"


func _on_trigger() -> void:
	var enemy = game.find_closest_enemy(self)
	if enemy:
		enemy.damage(50)
