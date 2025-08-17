@icon("res://assets/rooms/cannon.png")
extends Resource
class_name RoomResource

@export var tilemap_id: int
@export var display_name: String = ""
@export var cooldown_seconds: float = 0
@export var requires_enemies_to_trigger: bool = true
@export var icon: Texture2D
