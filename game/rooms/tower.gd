extends TileMapLayer
class_name Tower

var room_overlay = preload("res://game/rooms/room_overlay.tscn")

@onready var tower_overlay_node = $"../../TowerOverlay"

signal room_placed(room: int)
signal removal_service(room: Room)
signal sell(room: int)

var current_room: int = -1

var room_overlays: Dictionary[Vector2i, RoomOverlay] = {}
@onready var buildableIndicators = [$"../../BuildableIndicators/BuildableLocation1", $"../../BuildableIndicators/BuildableLocation2"]

const BG = 0
const PALISADES = 1
const SCAFFOLD = 2
const BOTTOM = 6
const PALISADES_MIRROR = 7
const BUILDABLE = 8

class RoomInstance:
	var type: Room
	var position: Vector2i

	var just_triggered: bool = false
	var cooldown_remaining: float
	var cooldown: float
	var bonus_projectiles: int = 0
	var extra_damage: int = 0
	var extra_pierce: int = 0
	
	# extra stuff for specific rooms
	var gym_extra_damage: float = 0
	var workshop_extra_coins: float = 1
	var funeral_parlor_scaling: int = 1
	var funeral_parlor_extra_damage: int = 0
	var music_room_cooldown_reduction: float = 0

	func _init(room_type: Room, pos: Vector2i):
		type = room_type
		position = pos
		cooldown = type.cooldown_seconds
		cooldown_remaining = type.cooldown_seconds

	func play_sound(tower: Tower, sound: String):
		tower.room_overlays[position].play_sound(sound)

	func reset_cooldown():
		cooldown_remaining = type.cooldown_seconds
		just_triggered = false

	func create_flavor_text(tower: Tower, text: String):
		tower.room_overlays[position].create_flavor_text(text)

	func trigger(tower: Tower) -> void:
		just_triggered = true
		if type.trigger_script:
			type.trigger_script.on_trigger(tower, self)
			if type.animate_on_trigger and tower.room_overlays.has(position):
				tower.room_overlays[position].time_since_fired = 0
		else:
			print("Room type: '" + type.display_name + "' has no triigger action")

	func can_fire(game: Game, tower: Tower):
		if type.trigger_script and "can_fire" in type.trigger_script:
			return type.trigger_script.can_fire(game, tower, self)
		else:
			return true

var rooms: Array[RoomInstance] = []

@onready var game: Game = $"../.."

func _ready():
	tower_overlay_node.global_position = global_position
	tower_overlay_node.scale = scale

	var used_cells = get_used_cells()
	for cell in used_cells:
		if (cell.y < 6):
			set_cell(cell, -1)
	redraw_castle()
	
	game.wave_start.connect(func():
		for room in rooms:
			room.reset_cooldown()
			room.music_room_cooldown_reduction = 0
		for overlay in room_overlays.values():
			overlay.wave_number = game.wave_number
	)
	game.wave_end.connect(func():
		for overlay: RoomOverlay in room_overlays.values():
			overlay.wave_number = game.wave_number
			overlay.flavor_text_queue = []
	)

func set_current_room(room: int) -> void:
	current_room = room

func show_buildable_locations(destroy=false):
	var heights = [6, 6]

	for target in room_overlays.keys():
		set_cell(target, BG, Vector2.ZERO)
		if heights[target.x] > target.y:
			heights[target.x] = target.y

	for i in range(2):
		var h = heights[i]
		if h < 2:
			continue
		var b = buildableIndicators[i]
		var show_at_h = h - 2
		if destroy:
			show_at_h += 1
			if h == 6:
				continue
		b.show()
		b.position = to_global(map_to_local(Vector2i(i, show_at_h)))
		i+=1

func hide_buildable_indicators():
	for b in buildableIndicators:
		b.hide()

func _input(event) -> void:
	if not event is InputEventMouseButton:
		return
	if event.is_pressed() or event.button_index != 1:
		return
	if current_room == -1:
		return

	var target = local_to_map(get_local_mouse_position())

	# We use the id -2 and the claw to destroy the room, and put it back on the bench
	# Dont you dare complain about the code
	if current_room == -2:
		# cant remove if the bench is full
		if $"../../UI/Rooms".is_full():
			return
		if room_overlays.has(target):
			var overlay = room_overlays[target]
			room_overlays.erase(target)
			rooms = rooms.filter(func(room: RoomInstance): return room.position != target)
			removal_service.emit(overlay.room)
			overlay.queue_free()
			$"../../UI/Rooms".dragging_crane = false
			redraw_castle()
		return
	
	if $"../../UI/TrashCan".hovered:
		sell.emit(current_room)
		return
	
	if target.x != 0 and target.x != 1:
		return
	if target.y < 1:
		return
	if target.y != 5 and get_cell_source_id(Vector2(target.x, target.y + 1)) not in [BG, SCAFFOLD]:
		return
	if get_cell_source_id(Vector2(target.x, target.y)) == BG:
		# Can not place a room where there is already a room
		return

	# Add the new room
	$"../../UI/Rooms".dragging_room = false
	hide_buildable_indicators()
	var new_overlay = room_overlay.instantiate()
	game.wave_end.connect(new_overlay.hide_progress)
	game.wave_start.connect(new_overlay.show_progress)
	room_overlays[target] = new_overlay
	new_overlay.position = map_to_local(target) - Vector2(232, 171)
	new_overlay.wave_number = game.wave_number
	tower_overlay_node.add_child(new_overlay)
	redraw_castle()

	room_overlays[target].room = game.purchased_rooms[current_room]
	rooms.append(
		RoomInstance.new(game.purchased_rooms[current_room], target)
	)
	room_placed.emit(current_room)
	current_room = -1

func redraw_castle():
	for cell in self.get_used_cells():
		set_cell(cell, -1, Vector2.ZERO)

	set_cell(Vector2(0, 6), BOTTOM, Vector2.ZERO)
	set_cell(Vector2(1, 6), BOTTOM, Vector2.ZERO)

	var heights = [6, 6]

	var i = 0
	
	for target in room_overlays.keys():
		if heights[target.x] > target.y:
			heights[target.x] = target.y

	for x in range(2):
		for y in range(1, 6):
			if y > heights[x]:
				set_cell(Vector2i(x, y), SCAFFOLD, Vector2.ZERO)

	for h in heights:
		if h != 6 and i == 0:
			set_cell(Vector2(i, h - 1), PALISADES, Vector2.ZERO)
		if h != 6 and i == 1:
			set_cell(Vector2(i, h - 1), PALISADES_MIRROR, Vector2.ZERO)
		i+=1
	
	for target in room_overlays.keys():
		set_cell(target, BG, Vector2.ZERO)

func _process(delta: float) -> void:
	if $"../../UI/Rooms".dragging_room:
		show_buildable_locations()
	elif $"../../UI/Rooms".dragging_crane:
		show_buildable_locations(true)
	else:
		hide_buildable_indicators()

	if !game.is_in_wave():
		return
	check_just_triggered()
	for room in rooms:
		room.cooldown_remaining -= delta

		if room.cooldown_remaining < 0:
			var can_fire = game.find_closest_enemy(room) or !room.type.requires_enemies_to_trigger
			if room.can_fire != null and can_fire:
				can_fire = room.can_fire(game, self)
			if can_fire:
				room.cooldown_remaining = max(room.type.cooldown_seconds  - room.music_room_cooldown_reduction, .2)
				room.trigger(self)
		
		if not room_overlays.has(room.position):
			return

		if room.type.cooldown_seconds > 0 and room.cooldown_remaining > 0:
			room_overlays[room.position].progress = room.cooldown_remaining / room.type.cooldown_seconds
		else:
			room_overlays[room.position].progress = 0

func fire_projectiles(room: RoomInstance, projectile: PackedScene, number: int, filter = null):
	fire_projectiles_with_target(room, projectile, number, game.fire_projectile_from_room, filter)

func fire_projectiles_above_enemy(room: RoomInstance, projectile: PackedScene, number: int, filter = null):
	fire_projectiles_with_target(room, projectile, number, game.fire_projectile_above_enemy, filter)

func fire_projectiles_with_target(room: RoomInstance, projectile: PackedScene, number: int, target_func: Callable, filter=null):
	var targets = game.find_n_closest_enemies(room, number + room.bonus_projectiles, filter)
	var this_volley_extra_damage = room.extra_damage
	var this_volley_extra_pierce = room.extra_pierce
	
	room.bonus_projectiles = 0
	room.extra_damage = 0
	room.extra_pierce = 0

	for target in targets:
		if target == null:
			continue
		room_overlays[room.position].time_since_fired = 0
		var projectileInst = projectile.instantiate()
		projectileInst.damage += this_volley_extra_damage + room.funeral_parlor_extra_damage
		projectileInst.pierce += this_volley_extra_pierce
		game.add_child(projectileInst)
		target_func.call(room, projectileInst, target)
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

func check_just_triggered():
	for room in rooms:
		if room.just_triggered:
			room.just_triggered = false
	
			# do something when the room just triggered
			for r in rooms:
				# SHURUKEN
				if r.type.display_name == "Shuriken":
					r.cooldown_remaining -= .2
					r.extra_damage += 2
					r.extra_pierce += 1
					r.create_flavor_text(self, "-.2s Cooldown")
				# GYM
				if r.type.display_name == "Gym":
					r.gym_extra_damage += .1
