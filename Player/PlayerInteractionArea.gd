extends Area2D

var objects_in_area = []

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.is_in_group("interactable"):
		objects_in_area.append(body)

func _on_body_exited(body):
	if body.is_in_group("interactable"):
		objects_in_area.erase(body)

func get_closest_object():
	if objects_in_area.empty():
		return null
	else:
		print("there is an object")
		objects_in_area.sort_custom(self, "compare_distance_to_player")
		return objects_in_area[0]

func compare_distance_to_player(a, b):
	var distance_a = a.global_position.distance_to(self.global_position)
	var distance_b = b.global_position.distance_to(self.global_position)

	if distance_a < distance_b:
		return -1
	elif distance_a > distance_b:
		return 1
	else:
		return 0
