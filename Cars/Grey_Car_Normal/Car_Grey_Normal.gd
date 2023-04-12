extends KinematicBody2D

const SPEED = 100
var velocity = Vector2.ZERO
const LIFETIME = 6.0
var timer = 0.0

func _physics_process(delta):
	timer += delta # Increment the timer by the time since the last frame
	if timer >= LIFETIME:
		queue_free() # Delete the car if the timer exceeds the LIFETIME
	else:
		velocity.x = -SPEED
		velocity = move_and_slide(velocity)
	
	
