extends Area2D

func _on_area_entered(area):
	if area is EnemyInstance and area.health > 0:
		$"..".deal_damage(area)
