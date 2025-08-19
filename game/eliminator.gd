extends Area2D

func _on_area_shape_entered(_area_rid, area, _area_shape_index, local_shape_index):
	var shape = shape_find_owner(local_shape_index)
	var collider = shape_owner_get_owner(shape)

	if area is EnemyInstance and collider.name == "Left" and area.health > 0:
		$"..".deal_damage(area)
	elif area.get_parent() is Projectile and collider.name != "Up" and collider.name != "Left":
		area.queue_free()
