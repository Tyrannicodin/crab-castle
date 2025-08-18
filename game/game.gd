extends Node2D
class_name Game

var enemies: Array[Enemy] = []
var tower = []

@onready var enemy_spawn_points = [
	$EnemySpawnPoints/Floor1,
	$EnemySpawnPoints/Floor2,
	$EnemySpawnPoints/Floor3,
	$EnemySpawnPoints/Floor4,
	$EnemySpawnPoints/Floor5,
]

func _ready() -> void:
	$GameStartBits.visible = true
	$Tower/Room.game = self
	$Tower/Room2.game = self
	$Tower/Room3.game = self
	$Tower/Room4.game = self
	$Tower/Room5.game = self
	$Tower/Room6.game = self
	$Tower/Room7.game = self
	$Tower/Room8.game = self
	$Tower/Room9.game = self
	$Tower/Room10.game = self
	
	tower = [
		[$Tower/Room, $Tower/Room2], # Floor one
		[$Tower/Room3, $Tower/Room4],
		[$Tower/Room5, $Tower/Room6],
		[$Tower/Room7, $Tower/Room8],
		[$Tower/Room9, $Tower/Room10], # Floor five
	]
	
	for i in range(10):
		_spawn_enemy()
		await get_tree().create_timer(1.0).timeout

func _spawn_enemy():
	# The level of the tower the enemy spawns on
	var layer = randi_range(0, len(enemy_spawn_points) - 1)
	var seagull: Enemy = load("res://game/enemies/Seagull.tscn").instantiate()
	enemy_spawn_points[layer].add_child(seagull)
	enemies.push_back(seagull)
	seagull.game = self

func has_enemies() -> bool:
	return len(enemies.filter(func(x: Enemy): return x.is_alive())) > 0

func find_closest_enemies(to_room: Room) -> Array[Enemy]:
	if !has_enemies():
		return []
	var alive_enemies = enemies.filter(func(x: Enemy): return x.is_alive())
	
	var in_range_enemies = alive_enemies.filter(func(e: Enemy):
		return abs((e.global_position - to_room.global_position).angle()) < PI / 8
	)
	
	in_range_enemies.sort_custom(func(a: Enemy, b: Enemy):
		return a.global_position.distance_squared_to(to_room.global_position) < b.global_position.distance_squared_to(to_room.global_position),
	)

	if (len(in_range_enemies) > 0):
		return in_range_enemies
	return []

func find_closest_enemy(to_room: Room) -> Enemy:
	var in_range_enemies = find_closest_enemies(to_room)
	if (len(in_range_enemies) > 0):
		return in_range_enemies[0]
	return null
	
func fire_projectile_from_room(room: Room, projectile: Node2D, target: Enemy):
	projectile.visible = true
	projectile.global_position = room.global_position
	projectile.aim(room.global_position, target)
