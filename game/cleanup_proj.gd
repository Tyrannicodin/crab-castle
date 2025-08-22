extends Area2D

func _on_area_entered(area):
	if area.get_parent() is Projectile:
		area.get_parent().queue_free()
