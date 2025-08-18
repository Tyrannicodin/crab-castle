@icon("res://assets/rooms/cannon.png")
extends Resource
class_name RoomResource

@export_category("images")
@export var tilemap_id: int
@export var tilemap_atlas_coords: Vector2i = Vector2i.ZERO
@export var icon: Texture2D

@export_category("information")
@export var display_name: String = ""
@export var cooldown_seconds: float = 0
@export var requires_enemies_to_trigger: bool = true
@export var visible_progress_bar: bool = true
@export_flags("up", "right", "down", "left") var visible_arrows: int = 0
