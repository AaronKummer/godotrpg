extends KinematicBody2D

const SPEED = 80
const INTERACTION_DISTANCE = 40

var velocity = Vector2.ZERO
var last_direction = Vector2.ZERO
var cpu: Node
onready var animation = $AnimationPlayer

func _ready():
	cpu = get_parent().get_node("cpu")

func _physics_process(delta):
	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var input_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if input_x != 0 or input_y != 0:
		last_direction = Vector2(input_x, input_y)

	if input_x > 0:
		velocity.x = SPEED
		animation.play("walk_right")
	elif input_x < 0:
		velocity.x = -SPEED
		animation.play("walk_left")
	elif input_y > 0:
		velocity.y = SPEED
		animation.play("walk_down")
	elif input_y < 0:
		velocity.y = -SPEED
		animation.play("walk_up")
	else:
		velocity = Vector2.ZERO
		play_idle_animation()

	velocity = move_and_slide(velocity)

	if is_close_to_cpu() and Input.is_action_just_pressed("action"):
		print("Entering the matrix")
		get_parent().get_parent().get_node("Terminal").open_terminal()

func is_close_to_cpu() -> bool:
	var distance = position.distance_to(cpu.position)
	return distance <= INTERACTION_DISTANCE

func play_idle_animation():
	if last_direction.y < 0:
		animation.play("idle_up")
	elif last_direction.y > 0:
		animation.play("idle_down")
	elif last_direction.x > 0:
		animation.play("idle_right")
	elif last_direction.x < 0:
		animation.play("idle_left")
