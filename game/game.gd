extends Node2D
class_name Game

var enemies = []

func _ready() -> void:
	$GameStartBits.visible = true
	_spawn_enemy()
	$Tower/Room.game = self
	$Tower/Room2.game = self
	$Tower/Room3.game = self


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
	#projectile.global_position = Vector2(0, 0)
	projectile.visible = true
	projectile.aim(room, target)
