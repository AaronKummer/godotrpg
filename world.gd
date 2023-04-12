extends Node2D

func _ready():
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()

	var x = (screen_size.x - window_size.x) / 2
	var y = (screen_size.y - window_size.y) / 2

	OS.set_window_position(Vector2(x, y))
