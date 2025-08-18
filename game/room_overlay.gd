extends Node2D
class_name RoomOverlay

var visible_arrows: int = 0
var visible_progress: bool = false
var progress: float = 0

func _process(_delta):
    for child in get_children():
        child.hide()
    if visible_arrows & 0b0001:
        $ArrowUp.show()
    if visible_arrows & 0b0010:
        $ArrowRight.show()
    if visible_arrows & 0b0100:
        $ArrowDown.show()
    if visible_arrows & 0b1000:
        $ArrowLeft.show()
    
    if visible_progress:
        $Progress.show()
        $Progress.value = progress
