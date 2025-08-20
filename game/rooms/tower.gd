extends TileMapLayer
class_name Tower

@onready var room_overlay = preload("res://game/rooms/room_overlay.tscn")

signal room_placed(room: int)

var current_room: int = -1

var room_overlays: Dictionary[Vector2i, RoomOverlay] = {}

const BG = 0
const PALISADES = 1
const BOTTOM = 6
const PALISADES_MIRROR = 7
const BUILDABLE = 8

class RoomInstance:
	var type: Room
	var position: Vector2i

	var cooldown_remaining: float
	var bonus_projectiles: int = 0

	func _init(room_type: Room, pos: Vector2i):
		type = room_type
		position = pos
		cooldown_remaining = type.cooldown_seconds

	func reset_cooldown():
		cooldown_remaining = type.cooldown_seconds

	func trigger(tower: Tower) -> void:
		if type.trigger_script:
			type.trigger_script.on_trigger(tower, self)
			if type.animate_on_trigger:
				tower.room_overlays[position].time_since_fired = 0
		else:
			print("Room type: '" + type.display_name + "' has no triigger action")
	

var rooms: Array[RoomInstance] = []

@onready var game = $"../.."

func _ready():
	var used_cells = get_used_cells()
	for cell in used_cells:
		if (cell.y < 6):
			set_cell(cell, -1)
	generate_room_sprites()
	
	game.wave_start.connect(func():
		for room in rooms:
			room.reset_cooldown()
	)

func generate_room_sprites() -> void:
	var used_cells = get_used_cells()
	for cell in used_cells:
		if room_overlays.has(cell):
			continue
		var overlay = room_overlay.instantiate()
		game.wave_end.connect(overlay.hide_progress)
		game.wave_start.connect(overlay.show_progress)
		room_overlays[cell] = overlay
		overlay.position = map_to_local(cell) - Vector2(232, 171)
		add_child(overlay)

func set_current_room(room: int) -> void:
	current_room = room

func _input(event) -> void:
	if not event is InputEventMouseButton:
		return
	if event.is_pressed() or event.button_index != 1:
		return
	if current_room == -1:
		return
	
	var target = local_to_map(get_local_mouse_position())
	var room_below = get_cell_source_id(get_neighbor_cell(target, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE))
	if (room_below != BOTTOM && room_below != BG):
		return
	set_cell(target, BG, Vector2(0,0))
	set_cell(Vector2(target.x, target.y-1), PALISADES_MIRROR if target.x == 1 else PALISADES, Vector2(0,0))
	generate_room_sprites()
	if room_overlays[target].room:
		# TODO: This is where stuff should happen when you click on a placed room
		return
	room_overlays[target].room = game.purchased_rooms[current_room]
	rooms.append(
		RoomInstance.new(game.purchased_rooms[current_room], target)
	)
	room_placed.emit(current_room)
	current_room = -1

func _process(delta: float) -> void:
	if !game.is_in_wave():
		return
	for room in rooms:
		room.cooldown_remaining -= delta

		if room.cooldown_remaining < 0:
			if game.find_closest_enemy(room) or !room.type.requires_enemies_to_trigger:
				room.cooldown_remaining = room.type.cooldown_seconds
				room.trigger(self)

		if room.type.cooldown_seconds > 0 and room.cooldown_remaining > 0:
			room_overlays[room.position].progress = room.cooldown_remaining / room.type.cooldown_seconds
		else:
			room_overlays[room.position].progress = 0

func fire_projectiles(room: RoomInstance, projectile: PackedScene, number: int):
	var targets = game.find_n_closest_enemies(room, number + room.bonus_projectiles)
	room.bonus_projectiles = 0

	for target in targets:
		room_overlays[room.position].time_since_fired = 0
		var projectileInst = projectile.instantiate()
		game.add_child(projectileInst)
		game.fire_projectile_from_room(room, projectileInst, target)
		await get_tree().create_timer(.1).timeout

func fire_projectiles_above_enemy(room: RoomInstance, projectile: PackedScene, number: int):
	var targets = game.find_n_closest_enemies(room, number + room.bonus_projectiles)
	room.bonus_projectiles = 0

	for target in targets:
		room_overlays[room.position].time_since_fired = 0
		var projectileInst = projectile.instantiate()
		game.add_child(projectileInst)
		game.fire_projectile_above_enemy(room, projectileInst, target)
		await get_tree().create_timer(.1).timeout

func get_room_global_position(room: RoomInstance) -> Vector2:
	return to_global(map_to_local(room.position))

func get_room_at_positon(pos: Vector2i) -> RoomInstance:
	var found_room = rooms.find_custom(func(room): return room.position == pos)
	if found_room == -1:
		return null
	return rooms[found_room]

func get_adjacent_rooms(room: RoomInstance) -> Dictionary[String, RoomInstance]:
	return {
		"up": get_room_at_positon(get_neighbor_cell(room.position, TileSet.CELL_NEIGHBOR_TOP_SIDE)),
		"right": get_room_at_positon(get_neighbor_cell(room.position, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)),
		"down": get_room_at_positon(get_neighbor_cell(room.position, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)),
		"left": get_room_at_positon(get_neighbor_cell(room.position, TileSet.CELL_NEIGHBOR_LEFT_SIDE)),
	}
