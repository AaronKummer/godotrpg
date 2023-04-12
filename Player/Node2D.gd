extends Node2D

func _draw():
	var collision_shape = get_parent()
	var shape = collision_shape.get_shape()
	if shape is RectangleShape2D:
		draw_rect(Rect2(-shape.extents, shape.extents * 2), Color(1, 0, 0, 0.5), false)

func _process(_delta):
	update()
