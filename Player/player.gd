extends KinematicBody2D

const ACCELERATION = 600
const MAX_SPEED  = 80
const FRICTION = 500

var velocity = Vector2.ZERO
var last_direction = Vector2.RIGHT
onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			last_direction = Vector2.RIGHT
			animationPlayer.play("RunRight")
		elif input_vector.x < 0:
			last_direction = Vector2.LEFT
			animationPlayer.play("RunLeft")
		elif input_vector.y < 0:
			animationPlayer.play("RunUp")
		elif input_vector.y > 0:
			animationPlayer.play("RunDown")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		if last_direction == Vector2.LEFT:
			animationPlayer.play("IdleLeft")
		else:
			animationPlayer.play("IdleRight")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)

	velocity = move_and_slide(velocity)
