extends Node

@onready var _file = ConfigFile.new()

func _ready():
    _file.load("user://options.cfg")

func set_value(param: String, value: Variant) -> void:
    _file.set_value("options", param, value)

func get_value(param: String, default = null) -> Variant:
    return _file.get_value("options", param, default)

func on_quit() -> void:
    _file.save("user://options.cfg")
