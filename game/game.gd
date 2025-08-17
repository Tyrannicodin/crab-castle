extends Node2D
class_name Game

var enemies = []
var tower = []

func _ready() -> void:
	$GameStartBits.visible = true
	_spawn_enemy()
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

func _spawn_enemy():
	# This will be what layer of the tower the enemy
	# spawns on once thats possible
	var layer = 1
	var seagull: Enemy = load("res://game/enemies/Seagull.tscn").instantiate()
	$EnemySpawnPoint.add_child(seagull)
	self.enemies.push_back(seagull)
	seagull.game = self
	seagull.on_death.connect(func(e: Enemy):
		e.queue_free()
		enemies = enemies.filter(func(e_): e.get_instance_id() != e_.get_instance_id())
	)

func has_enemies() -> bool:
	return len(enemies) > 0

func find_closest_enemy(to_room) -> Enemy:
	if len(enemies) == 0:
		return null
	return enemies[0]

func fire_projectile_from_room(room: Room, projectile: Node2D, target: Enemy):
	var fire_from_floor = 0
	var i = 1
	for floor in tower:
		if room in floor:
			fire_from_floor = i
			break
		i += 1

	var origin: Vector2

	if i == 1:
		origin = $ProjectileSpawnPoints/Floor1.global_position
	if i == 2:
		origin = $ProjectileSpawnPoints/Floor2.global_position
	if i == 3:
		origin = $ProjectileSpawnPoints/Floor3.global_position
	if i == 4:
		origin = $ProjectileSpawnPoints/Floor4.global_position
	if i == 5:
		origin = $ProjectileSpawnPoints/Floor5.global_position

	projectile.visible = true
	projectile.global_position = origin
	projectile.aim(origin, target)
