@icon("res://assets/rooms/cannon.png")
extends Resource
class_name Room

@export var display_name: String = ""

@export_category("display")
@export var image: Texture2D
@export var scale: Vector2 = Vector2(.3, .3)
## Should the pulse animation play on trigger. Should be false for projectile rooms.
@export var animate_on_trigger: bool = false

@export var visible_progress_bar: bool = true
@export_flags("up", "right", "down", "left") var visible_arrows: int = 0

@export_category("stats")
@export var trigger_script: GDScript
@export var cooldown_seconds: float = 0
@export var requires_enemies_to_trigger: bool = true
