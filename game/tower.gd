extends TileMapLayer
class_name Tower

var room_overlay = preload("res://game/room_overlay.tscn")

var available_rooms: Array[Room] = []
var current_room: Room = null

var room_overlays: Dictionary[Vector2i, RoomOverlay] = {}

class RoomInstance:
	var type: Room
	var position: Vector2i

	var cooldown_remaining: float
	var time_since_fired: float = 0
	var bonus_projectiles: int = 0

	func _init(room_type: Room, pos: Vector2i):
		type = room_type
		position = pos
		cooldown_remaining = type.cooldown_seconds
	
	func trigger(tower: Tower) -> void:
		if type.trigger_script:
			type.trigger_script.on_trigger(tower, self)
		else:
			print("Room type: '" + type.display_name + "' has no triigger action")
	

var rooms: Array[RoomInstance] = []

@onready var game = $".."

func _ready():
	print(game)
	load_rooms()
	generate_room_sprites()

func load_rooms():
	for file_name in DirAccess.get_files_at("res://assets/resources/rooms"):
		if (file_name.get_extension() == "import"):
			file_name = file_name.replace('.import', '')
		var resource = null
		if file_name.ends_with(".tres"):
			resource = ResourceLoader.load("res://assets/resources/rooms/" + file_name)
		if resource is Room:
			available_rooms.append(resource) 

func generate_room_sprites() -> void:
	var used_cells = $AvailableRooms.get_used_cells()
	for cell in used_cells:
		var overlay = room_overlay.instantiate()
		room_overlays[cell] = overlay
		overlay.position = $AvailableRooms.map_to_local(cell) - Vector2(120, 90)
		add_child(overlay)

func set_current_room(room: Room) -> void:
	current_room = room

func _input(event) -> void:
	if not event is InputEventMouseButton:
		return
	if event.is_pressed() or event.button_index != 1:
		return
		
	var target = local_to_map(get_local_mouse_position())
	if not target in $AvailableRooms.get_used_cells():
		return
	var cell = get_cell_source_id(target)
	if cell == -1:
		# TODO: implement place logic
		if not current_room:
			return
		set_cell(target, current_room.tilemap_id, Vector2i.ZERO)
		room_overlays[target].visible_arrows = current_room.visible_arrows
		room_overlays[target].visible_progress = current_room.visible_progress_bar
		rooms.append(RoomInstance.new(current_room, target))
		return
	# TODO: This is where stuff should happen when you click on a room 

func _process(delta: float) -> void:
	for room in rooms:
		room.cooldown_remaining -= delta
		room.time_since_fired += delta

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
		var projectileInst = projectile.instantiate()
		game.add_child(projectileInst)
		game.fire_projectile_from_room(room, projectileInst, target)
		await get_tree().create_timer(.1).timeout

func fire_projectiles_above_enemy(room: RoomInstance, projectile: PackedScene, number: int):
	var targets = game.find_n_closest_enemies(room, number + room.bonus_projectiles)
	room.bonus_projectiles = 0

	for target in targets:
		var projectileInst = projectile.instantiate()
		game.add_child(projectileInst)
		game.fire_projectile_above_enemy(self, projectileInst, target)
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
