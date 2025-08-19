extends "res://game/projectiles/projectile.gd"

func _on_area_2d_area_entered(area: Area2D) -> void:
	if disabled:
		return

	if area is not EnemyInstance:
		return

	var first_enemy: EnemyInstance = area

	if !first_enemy.is_alive():
		return

	if remaining_pierce == 0:
		self.queue_free()
		self.disable()
	else:
		remaining_pierce -= 1

	for enemy in $ExplosionRadius.get_overlapping_areas():
		if enemy is not EnemyInstance:
			continue
		enemy.damage(damage)
		enemy.stun_lock(stun_lock)
		enemy.knockback(knockback)
