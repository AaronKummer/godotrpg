extends KinematicBody2D

const SPEED = 80
const INTERACTION_DISTANCE = 40
var velocity = Vector2.ZERO
var last_direction = Vector2.ZERO
var cpu: Node
onready var animation = $AnimationPlayer
onready var interaction_area = $PlayerInteractionArea
onready var interaction_shape = $PlayerInteractionArea/CollisionShape2D

onready var dialog_scene = load("res://dialogs/Dialog.tscn")
var terminal_output = null
var dialog_text = null
# onready var dialogtext = load("res://Dialogs/Dialog.tscn").find_node("Panel/RichTextLabel")
# onready var dialogbox = load("res://Dialogs/Dialog.tscn").find_node("Dialog")


var options = ["Exit", "Pick up", "Use"]
var current_option_index = 0
var items = []

func _ready():
	cpu = get_parent().get_node("cpu")
	var terminal_node = get_node("../../Terminal")  # replace with the correct path
	terminal_output = terminal_node.get_node("TerminalOutput")



func can_pickup():
	if interaction_area.get_closest_object().name == "cpu":
		return true

func display_options():
	terminal_output.clear()
	for i in range(len(options)):
		if i == current_option_index:
			terminal_output.append_bbcode("[color=red]" + options[i] + "[/color]")
		else:
			terminal_output.append_bbcode(options[i])
		terminal_output.newline()

func check_front():
	var closest_object = interaction_area.get_closest_object()
	if closest_object:
		terminal_output.visible = true
		if closest_object.name == "cpu":
			terminal_output.append_bbcode("This appears to be a cyber deck sitting on the side of the road.")
			terminal_output.newline()
			terminal_output.append_bbcode("What do you want to do?")
			display_options()

func _physics_process(delta):
	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var input_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	velocity = Vector2(input_x, input_y).normalized() * SPEED

	if velocity.length() > 0:
		last_direction = velocity.normalized()

		if input_x > 0:
			animation.play("walk_right")
		elif input_x < 0:
			animation.play("walk_left")
		elif input_y > 0:
			animation.play("walk_down")
		elif input_y < 0:
			animation.play("walk_up")
	else:
		play_idle_animation()

	velocity = move_and_slide(velocity)

	# Set the position of the interaction_area
	interaction_shape.position = Vector2.ZERO

	var interaction_offset = 20
	if last_direction.y < 0:
		interaction_shape.rotation = 0
		interaction_shape.position = Vector2(45, -20)
	elif last_direction.y > 0:
		interaction_shape.rotation = deg2rad(180)
		interaction_shape.position = Vector2(45, 10)
	elif last_direction.x < 0:
		interaction_shape.rotation = deg2rad(270)
		interaction_shape.position = Vector2(40, 0)
	elif last_direction.x > 0:
		interaction_shape.rotation = deg2rad(90)
		interaction_shape.position = Vector2(50, 0)
	
	if not terminal_output.visible:
		if Input.is_action_just_pressed("action"):
			check_front()
			print("doing action")
			
	else:
		if Input.is_action_just_pressed("ui_up"):
			current_option_index -= 1
			if current_option_index < 0:
				current_option_index = len(options) - 1
			display_options()
		if Input.is_action_just_pressed("ui_down"):
			current_option_index += 1
			if current_option_index >= len(options):
				current_option_index = 0
			display_options()
			
		if Input.is_action_just_pressed("action"):
			if current_option_index == 0:
				terminal_output.visible = false
			if current_option_index == 1:
				if can_pickup():
					items.append(interaction_area.get_closest_object().name)
					interaction_area.get_closest_object().queue_free()
					terminal_output.visible = false
			if current_option_index == 2:
				var node_name = interaction_area.get_closest_object().name
				print(node_name)
				var thing = get_node("..").get_node("cpu")
				thing.use()
				terminal_output.visible = false

		print(items)



func play_idle_animation():
	if last_direction.y < 0:
		animation.play("idle_up")
	elif last_direction.y > 0:
		animation.play("idle_down")
	elif last_direction.x > 0:
		animation.play("idle_right")
	elif last_direction.x < 0:
		animation.play("idle_left")

			
