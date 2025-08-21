extends Node2D
class_name Game

signal rooms_loaded(rooms: Array[Room])
signal balance_changed(value: int)
signal wave_start
signal wave_end
signal game_end
signal damage_taken(remaining_health: int)

var available_rooms: Array[Room] = []
var purchased_rooms: Array[Room] = []

var bg_water_levels = [
	0.2,
	0.4,
	0.5,
	0.6,
	0.7,
]

@onready var viewport = $TowerViewport
@onready var tower = $TowerViewport/Tower
var money: float = 12.:
	set(value):
		if value > money:
			money_earned += value - money
		balance_changed.emit(value)
		money = value
		check_can_use_removal_service()

@onready var enemy_manager = $EnemyManager
var tower_health = 150 : 
	set(value):
		if value < money:
			total_damage_taken += tower_health - value
		tower_health = value

var waves = preload("res://game/enemy_waves.gd").waves
var scaling = preload("res://game/scaling.gd").new()
var wave_number = 0
var in_wave = false

var enemy_waves_cleared = 0
var enemy_waves_spawned = 0
var current_enemy_wave = []
var current_wave_enemy_count = 0
var finished_spawning = false
var water_level = 0
var removal_service_price = 2

var money_earned: float = 0
var kills: int = 0
var rooms_built: int = 0
var total_damage_taken: int = 0

func is_in_wave() -> bool:
	return in_wave

func _ready() -> void:
	balance_changed.emit(money)
	$BgSkyWater.material.set_shader_parameter("water_height", bg_water_levels[water_level])
	$TowerTexture.material.set_shader_parameter("water_height", bg_water_levels[water_level])
	$SkyReflection.material.set_shader_parameter("water_height", bg_water_levels[water_level])
	$"UI/Bench/Crane Tooltip".cost = removal_service_price
	load_rooms()
	$UpgradeUi.balance_changed.connect(func(m): money = m)
	on_wave_end(false)

func _process(delta: float) -> void:
	if in_wave:
		try_spawn_next_enemy_wave()

	$BgSkyWater.material.set_shader_parameter("water_height",
		lerp(
			$BgSkyWater.material.get_shader_parameter("water_height"),
			bg_water_levels[water_level],
			3 * delta
		)
	)
	$TowerTexture.material.set_shader_parameter("water_height",
		lerp(
			$TowerTexture.material.get_shader_parameter("water_height"),
			bg_water_levels[water_level],
			3 * delta
		)
	)
	$SkyReflection.material.set_shader_parameter("water_height",
		lerp(
			$SkyReflection.material.get_shader_parameter("water_height"),
			bg_water_levels[water_level],
			3 * delta
		)
	)
func _input(event):
	viewport.push_input(event)

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

# Run when a wave ends and at the start
func on_wave_end(wait_for_wave=true):
	var last_water_level = water_level
	if wave_number < len(waves):
		water_level = waves[wave_number].call()["water_level"]
	else:
		water_level = 0

	money += 10

	in_wave = false

	if wait_for_wave:
		if water_level != last_water_level:
			await get_tree().create_timer(1.5).timeout
		else:
			await get_tree().create_timer(.5).timeout

	if wave_number >= len(waves):
		game_end.emit()
		return

	$"UI/wave_number".text = "Wave " + str(wave_number + 1)
	
	if !$"UI/Rooms".is_full():
		$"UpgradeUi".roll_rooms(wave_number)

	wave_end.emit()

func on_wave_start():
	in_wave = true
	enemy_waves_cleared = 0
	enemy_waves_spawned = 0
	wave_number += 1
	current_enemy_wave = waves[wave_number - 1].call()
	$"UI/Start Next Wave".disabled = true
	water_level = current_enemy_wave["water_level"]
	
	wave_start.emit()

func try_spawn_next_enemy_wave():
	if $EnemyManager.living_enemy_count() <= floor(current_wave_enemy_count / 2.0) and enemy_waves_spawned > 0 and finished_spawning:
		enemy_waves_cleared += 1
	if enemy_waves_cleared < enemy_waves_spawned:
		return
	enemy_waves_spawned += 1
	if len(current_enemy_wave["enemies"]) <= enemy_waves_cleared:
			if $EnemyManager.living_enemy_count() == 0:
				on_wave_end()
			return
	current_wave_enemy_count = len(current_enemy_wave["enemies"][enemy_waves_cleared])
	finished_spawning = false
	for enemy in current_enemy_wave["enemies"][enemy_waves_cleared]:
		if typeof(enemy) == TYPE_ARRAY:
			$EnemyManager.spawn_enemy(wave_number, enemy[0], enemy[1])
		else:
			$EnemyManager.spawn_enemy(wave_number, enemy, 0)
		await get_tree().create_timer(.5).timeout
	finished_spawning = true


func find_closest_enemies(to_room: Tower.RoomInstance, filter = null) -> Array[EnemyInstance]:
	var room_positon = tower.get_room_global_position(to_room)
	return enemy_manager.find_closest_enemies(room_positon, filter)

func find_closest_enemy(to_room: Tower.RoomInstance, filter = null) -> EnemyInstance:
	var in_range_enemies = find_closest_enemies(to_room, filter)
	if (len(in_range_enemies) > 0):
		return in_range_enemies[0]
	return null

# Try to find N unique enemies for a weapon to attack. Repeat enemies if there is not enough in range.
func find_n_closest_enemies(to_room: Tower.RoomInstance, n: int, filter=null) -> Array[EnemyInstance]:
	var in_range_enemies = find_closest_enemies(to_room, filter)
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

func room_placed(room: int) -> void:
	rooms_built += 1
	purchased_rooms.remove_at(room)

func enemy_killed(enemy: Enemy) -> void:
	kills += 1
	money += scaling.scale_gold_gained(enemy.value, wave_number)

func deal_damage(enemy: EnemyInstance) -> void:
	if enemy.attack_success:
		return
	tower_health -= enemy.health
	enemy.attack_successful()
	$UI/health_display.text = str(tower_health)
	
	if tower_health <= 0:
		on_death()

	damage_taken.emit(tower_health)

func on_death():
	game_end.emit()

func _on_start_next_wave_button_down() -> void:
	on_wave_start()

func _on_game_end() -> void:
	get_tree().call_group("statistic", "update_stat", self)

func check_can_use_removal_service():
	$"UI/Bench/Crane".disabled = money < removal_service_price

func _on_tower_removal_service() -> void:
	money -= removal_service_price
	removal_service_price += 2
	$"UI/Bench/Crane Tooltip".cost = removal_service_price


func _on_rooms_sell(value: int) -> void:
	money += value
