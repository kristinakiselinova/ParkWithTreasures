extends Label

func _ready():
	var viewport_size = get_viewport_rect().size
	var label = $GameOver/CanvasLayer/ColorRect/Label

	label.set_position(viewport_size / 2 - label.size / 2)
