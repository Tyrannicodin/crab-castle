extends Node2D


func spawn_enemy():
	# This will be what layer of the tower the enemy
	# spawns on once thats possible
	var layer = 1
	var seagull: Enemy = load("res://game/enemies/Seagull.tscn").instantiate()
	$EnemySpawnPoint.add_child(seagull)
	print(seagull.global_position)

func _ready() -> void:
	spawn_enemy()
