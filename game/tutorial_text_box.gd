@tool
extends Node2D

@export_multiline var text: String = ""

func _ready():
	$PanelContainer/Label.text = text
