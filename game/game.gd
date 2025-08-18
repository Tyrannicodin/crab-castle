extends Node2D
class_name Game

var enemies: Array[Enemy] = []
@onready var tower = $TowerMap

@onready var enemy_spawn_points = [
	$EnemySpawnPoints/Floor1,
	$EnemySpawnPoints/Floor2,
	$EnemySpawnPoints/Floor3,
	$EnemySpawnPoints/Floor4,
	$EnemySpawnPoints/Floor5,
]

func _ready() -> void:
	$GameStartBits.visible = true
	
	for i in range(20):
		_spawn_enemy()
		await get_tree().create_timer(0.5).timeout

func _spawn_enemy():
	# The level of the tower the enemy spawns on
	var layer = randi_range(0, len(enemy_spawn_points) - 1)
	var seagull: Enemy = load("res://game/enemies/Seagull.tscn").instantiate()
	enemy_spawn_points[layer].add_child(seagull)
	enemies.push_back(seagull)
	seagull.game = self

func has_enemies() -> bool:
	return len(enemies.filter(func(x: Enemy): return x.is_alive())) > 0

func find_closest_enemies(to_room: Tower.RoomInstance) -> Array[Enemy]:
	if !has_enemies():
		return []
	var room_position = tower.get_room_global_position(to_room)
	var alive_enemies = enemies.filter(func(x: Enemy): return x.is_alive())
	
	var in_range_enemies = alive_enemies.filter(func(e: Enemy):
		return abs((e.global_position - room_position).angle()) < PI / 8
	)
	
	in_range_enemies.sort_custom(func(a: Enemy, b: Enemy):
		return a.global_position.distance_squared_to(room_position) < b.global_position.distance_squared_to(room_position),
	)

	if (len(in_range_enemies) > 0):
		return in_range_enemies
	return []

func find_closest_enemy(to_room: Tower.RoomInstance) -> Enemy:
	var in_range_enemies = find_closest_enemies(to_room)
	if (len(in_range_enemies) > 0):
		return in_range_enemies[0]
	return null

# Try to find N unique enemies for a weapon to attack. Repeat enemies if there is not enough in range.
func find_n_closest_enemies(to_room: Tower.RoomInstance, n: int) -> Array[Enemy]:
	var in_range_enemies = find_closest_enemies(to_room)
	if len(in_range_enemies) == 0:
		return []
	
	if len(in_range_enemies) > n:
		return in_range_enemies.slice(0, n)

	var out = in_range_enemies.duplicate()
	for i in range(n - len(in_range_enemies)):
		out.push_back(in_range_enemies.pick_random())

	return out

func fire_projectile_from_room(room: Tower.RoomInstance, projectile: Node2D, target: Enemy):
	var room_positon: Vector2 = tower.get_room_global_position(room)
	projectile.visible = true
	projectile.global_position = room_positon
	projectile.aim(room_positon, target)

func fire_projectile_above_enemy(_room: Tower.RoomInstance, projectile: Node2D, target: Enemy):
	projectile.visible = true
	projectile.global_position = target.global_position + Vector2(0, -50)
