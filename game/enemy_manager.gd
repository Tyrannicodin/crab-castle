extends Node2D

var enemy_base = preload("res://game/enemies/enemy.tscn")

func spawn_enemy(enemy: EnemyResource) -> void:
	var new_enemy = enemy_base.instantiate()
	new_enemy.enemy = enemy
	var layer = randi_range(0, get_child_count() - 1)
	get_child(layer).add_child(new_enemy)
	new_enemy.position = Vector2.ZERO

func get_all_enemies() -> Array[EnemyInstance]:
	var all_children: Array[EnemyInstance] = []
	for child in get_children():
		for grandchild in child.get_children():
			if grandchild is EnemyInstance:
				all_children.append(grandchild)
	return all_children

func has_enemies() -> bool:
	return len(get_all_enemies().filter(func(x: EnemyInstance): return x.is_alive())) > 0

func find_closest_enemies(to: Vector2) -> Array[EnemyInstance]:
	if !has_enemies():
		return []
	var alive_enemies = get_all_enemies().filter(func(x: EnemyInstance): return x.is_alive())
	
	var in_range_enemies = alive_enemies.filter(func(e: EnemyInstance):
		return abs((e.global_position - to).angle()) < PI / 8
	)
	
	in_range_enemies.sort_custom(func(a: EnemyInstance, b: EnemyInstance):
		return a.global_position.distance_squared_to(to) < b.global_position.distance_squared_to(to),
	)

	if (len(in_range_enemies) > 0):
		return in_range_enemies
	return []

func living_enemy_count():
	return len(get_all_enemies().filter(func(x: EnemyInstance): return x.is_alive()))
