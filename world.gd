extends Node2D

const greyCar = preload("res://Cars/Grey_Car_Normal/Car_Grey_Normal.tscn")

func spawn_car(pos: Vector2):
	var car_instance = greyCar.instance()
	car_instance.position = pos
	add_child(car_instance)
	return car_instance

func _ready():
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()

	var x = (screen_size.x - window_size.x) / 2
	var y = (screen_size.y - window_size.y) / 2

	OS.set_window_position(Vector2(x, y))
	
	var car_spawns_pos = Vector2(100,200)
	spawn_car(car_spawns_pos)
