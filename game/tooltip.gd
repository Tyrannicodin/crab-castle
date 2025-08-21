extends CanvasLayer
class_name Tooltip

func set_description(n: String, desc: String):
	$PanelContainer/VBoxContainer/name.text = n
	$PanelContainer/VBoxContainer/description.text = desc

func show_cost(value: int):
	$PanelContainer/VBoxContainer/Cost.show()
	$PanelContainer/VBoxContainer/Cost/Label.text = str(value)

func set_position(pos: Vector2i):
	$PanelContainer.global_position = pos

func get_position():
	return $PanelContainer.global_position

func sell_price(value: int):
	$PanelContainer/VBoxContainer/Sell.show()
	$PanelContainer/VBoxContainer/Sell/SellValue.text = str(value)
