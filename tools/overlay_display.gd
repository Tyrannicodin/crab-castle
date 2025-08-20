@tool
extends TileMapLayer

var overlay = preload("res://game/rooms/room_overlay.tscn")
var overlay_inst: RoomOverlay

@export var room: Room :
	set(value):
		room = value
		if overlay_inst:
			overlay_inst.room = value

func _ready():
	overlay_inst = overlay.instantiate()
	add_child(overlay_inst)
