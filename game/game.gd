extends Node2D
class_name Game

signal rooms_loaded(rooms: Array[Room])
signal add_room(room: Room)

var available_rooms: Array[Room] = []
var purchased_rooms: Array[Room] = []

@onready var tower = $Tower
@onready var enemy_manager = $EnemyManager

var waves = preload("res://game/enemy_waves.gd").new().waves
var wave_number = 0
var in_wave = false

var enemy_waves_cleared = 0
var enemy_waves_spawned = 0
var current_enemy_wave = []
var current_wave_enemy_count = 0

func _ready() -> void:
	load_rooms()
	$GameStartBits.visible = true
	on_wave_end()

func _process(delta: float) -> void:
	if in_wave:
		try_spawn_next_enemy_wave()

func load_rooms():
	available_rooms = []
	for file_name in DirAccess.get_files_at("res://assets/resources/rooms"):
		if (file_name.get_extension() == "import"):
			file_name = file_name.replace('.import', '')
		var resource = null
		if file_name.ends_with(".tres"):
			resource = ResourceLoader.load("res://assets/resources/rooms/" + file_name)
		if resource is Room:
			available_rooms.append(resource) 
	rooms_loaded.emit(available_rooms)

func _spawn_enemy():
	# The level of the tower the enemy spawns on
	$EnemyManager.spawn_enemy(preload("res://assets/resources/enemies/seagull.tres"))

# Run when a wave ends and at the start
func on_wave_end():
	in_wave = false
	var damage_only = wave_number < 2
	$"UpgradeUi".roll_rooms(damage_only)
	$"UpgradeUi".show()
	$"UI/Start Next Wave".show()

func on_wave_start():
	in_wave = true
	enemy_waves_cleared = 0
	enemy_waves_spawned = 0
	wave_number += 1
	current_enemy_wave = waves[wave_number - 1].call()

	$"UI/Start Next Wave".hide()

func try_spawn_next_enemy_wave():
	if $EnemyManager.living_enemy_count() <= (current_wave_enemy_count / 2) and enemy_waves_spawned > 0:
		enemy_waves_cleared += 1
	if enemy_waves_cleared < enemy_waves_spawned:
		return
	enemy_waves_spawned += 1
	if len(current_enemy_wave) <= enemy_waves_cleared:
			if $EnemyManager.living_enemy_count() == 0:
				on_wave_end()
			return
	current_wave_enemy_count = len(current_enemy_wave[enemy_waves_cleared])
	for enemy in current_enemy_wave[enemy_waves_cleared]:
		$EnemyManager.spawn_enemy(enemy)

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

func room_selected(room: Room) -> void:
	purchased_rooms.append(room)
	add_room.emit(room)

func room_placed(room: int) -> void:
	purchased_rooms.remove_at(room)


func _on_start_next_wave_button_down() -> void:
	on_wave_start()
