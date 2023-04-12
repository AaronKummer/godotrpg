extends KinematicBody2D

const SPEED = 80
const INTERACTION_DISTANCE = 40  # Change this value to set the interaction distance

var velocity = Vector2.ZERO
var cpu: Node

func _ready():
	cpu = get_parent().get_node("cpu")

func _physics_process(delta):
	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var input_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_x != 0:
		velocity.x = input_x * SPEED
		velocity.y = 0
	elif input_y != 0:
		velocity.x = 0
		velocity.y = input_y * SPEED
	else:
		velocity = Vector2.ZERO

	velocity = move_and_slide(velocity)

	if is_close_to_cpu() and Input.is_action_just_pressed("open_terminal"):
		print("Entering the matrix")
		get_parent().get_parent().get_node("Terminal").open_terminal()

func is_close_to_cpu() -> bool:
	var distance = position.distance_to(cpu.position)
	return distance <= INTERACTION_DISTANCE
