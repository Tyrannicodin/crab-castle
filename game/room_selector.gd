extends HBoxContainer

var rooms: Array[Room] = []

signal room_selected(room: Room)

func _ready():
	load_rooms()
	for room in rooms:
		var but = TextureButton.new()
		but.texture_normal = room.icon
		but.ignore_texture_size = true
		but.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		but.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		but.connect("pressed", func(): room_selected.emit(room))
		add_child(but)

func load_rooms():
	for file_name in DirAccess.get_files_at("res://assets/resources/rooms"):
		if (file_name.get_extension() == "import"):
			file_name = file_name.replace('.import', '')
		var resource = null
		if file_name.ends_with(".tres"):
			resource = ResourceLoader.load("res://assets/resources/rooms/" + file_name)
		if resource is Room:
			rooms.append(resource) 
