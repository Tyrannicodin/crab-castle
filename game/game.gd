extends Node2D
class_name Game

@onready var tower = $Tower
@onready var enemy_manager = $EnemyManager

func _ready() -> void:
	$GameStartBits.visible = true
	
	for i in range(20):
		_spawn_enemy()
		await get_tree().create_timer(0.5).timeout

func _spawn_enemy():
	# The level of the tower the enemy spawns on
	$EnemyManager.spawn_enemy(preload("res://assets/resources/enemies/seagull.tres"))


func find_closest_enemies(to_room: Tower.RoomInstance) -> Array[EnemyInstance]:
	var room_positon = tower.get_room_global_position(to_room)
	return enemy_manager.find_closest_enemies(room_positon)

func find_closest_enemy(to_room: Tower.RoomInstance) -> EnemyInstance:
	var in_range_enemies = find_closest_enemies(to_room)
	if (len(in_range_enemies) > 0):
		return in_range_enemies[0]
	return null

# Try to find N unique enemies for a weapon to attack. Repeat enemies if there is not enough in range.
func find_n_closest_enemies(to_room: Tower.RoomInstance, n: int) -> Array[EnemyInstance]:
	var in_range_enemies = find_closest_enemies(to_room)
	if len(in_range_enemies) == 0:
		return []
	
	if len(in_range_enemies) > n:
		return in_range_enemies.slice(0, n)

	var out = in_range_enemies.duplicate()
	for i in range(n - len(in_range_enemies)):
		out.push_back(in_range_enemies.pick_random())

	return out

func fire_projectile_from_room(room: Tower.RoomInstance, projectile: Node2D, target: EnemyInstance):
	var room_positon: Vector2 = tower.get_room_global_position(room)
	projectile.visible = true
	projectile.global_position = room_positon
	projectile.aim(room_positon, target)

func fire_projectile_above_enemy(_room: Tower.RoomInstance, projectile: Node2D, target: EnemyInstance):
	projectile.visible = true
	projectile.global_position = target.global_position + Vector2(0, -50)
