extends Node2D

var enemy_base = preload("res://game/enemies/enemy.tscn")

var scaling: Scaling = preload("res://game/scaling.gd").new()

func spawn_enemy(wave_number: int, enemy: Enemy) -> void:
	var new_enemy = enemy_base.instantiate()
	new_enemy.death.connect($"..".enemy_killed)
	new_enemy.enemy = enemy
	new_enemy.health = int(scaling.scale_enemy_hp(wave_number, enemy.max_health))

	var water_level = $"..".water_level

	var layer_count = get_child_count() - 1
	var layer = 0
	
	if enemy.underwater:
		layer = randi_range(0, water_level - 1)
	else:
		layer = randi_range(water_level, layer_count)

	get_child(layer).add_child(new_enemy)
	new_enemy.position = Vector2.ZERO
	new_enemy.underwater = enemy.underwater

func get_all_enemies() -> Array[EnemyInstance]:
	var all_children: Array[EnemyInstance] = []
	for child in get_children():
		for grandchild in child.get_children():
			if grandchild is EnemyInstance:
				all_children.append(grandchild)
	return all_children

func has_enemies() -> bool:
	return len(get_all_enemies().filter(func(x: EnemyInstance): return x.is_alive())) > 0

func find_closest_enemies(to: Vector2, filter = null) -> Array[EnemyInstance]:
	if !has_enemies():
		return []
	var alive_enemies = get_all_enemies().filter(func(x: EnemyInstance): return x.is_alive())
	if filter != null:
		alive_enemies = alive_enemies.filter(filter)
		if len(alive_enemies) == 0:
			return []
	var in_range_enemies = alive_enemies.filter(func(e: EnemyInstance):
		return (e.global_position - to).length() < 2000
	)
	
	in_range_enemies.sort_custom(func(a: EnemyInstance, b: EnemyInstance):
		return a.global_position.distance_squared_to(to) < b.global_position.distance_squared_to(to),
	)

	if (len(in_range_enemies) > 0):
		return in_range_enemies
	return []

func living_enemy_count():
	return len(get_all_enemies().filter(func(x: EnemyInstance): return x.is_alive()))
