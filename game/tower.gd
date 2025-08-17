extends TileMapLayer

var rooms: Array[RoomResource] = []

func _ready():
	load_rooms()

func load_rooms():
	for file_name in DirAccess.get_files_at("res://assets/resources/rooms"):
		if (file_name.get_extension() == "import"):
			file_name = file_name.replace('.import', '')
		print(file_name)
		rooms.append(ResourceLoader.load("res://assets/resources/rooms/" + file_name)) 

func _input(event) -> void:
	if not event is InputEventMouseButton:
		return
	if event.is_pressed() or event.button_index != 1:
		return
		
	var target = local_to_map(get_local_mouse_position())
	var cell = get_cell_source_id(target)
	if cell == -1:
		# TODO: implement place logic
		return
	var room = rooms[rooms.find_custom(
		func(res: RoomResource): return res.tilemap_id == cell
	)]
	print(room.display_name)
