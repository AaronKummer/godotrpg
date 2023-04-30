extends KinematicBody2D

const SPEED = 80
const INTERACTION_DISTANCE = 40

var velocity = Vector2.ZERO
var last_direction = Vector2.ZERO
var cpu: Node
var dialog_open = false
var dialog_just_opened = false
var terminal_open = false

onready var animation = $AnimationPlayer
onready var interaction_area = $PlayerInteractionArea
onready var interaction_shape = $PlayerInteractionArea/CollisionShape2D

onready var dialog_canvas = get_node("../../../world/DialogCanvasLayer")
onready var terminal = dialog_canvas.get_node("Terminal")
onready var dialog_root = dialog_canvas.get_node("Dialog")
onready var dialog_panel = dialog_root.get_node("Panel")
onready var dialog_text = dialog_panel.get_node("RichTextLabel")

var options = ["Exit", "Pick up", "Use"]
var current_option_index = 0
var items = []

func _ready():
	cpu = get_parent().get_node("cpu")
	terminal.connect("terminal_closed", self, "_on_terminal_closed")

func can_pickup():
	return interaction_area.get_closest_object().name == "cpu"

func _on_terminal_closed():
	terminal_open = false

func check_front():
	var closest_object = interaction_area.get_closest_object()
	if closest_object:
		if closest_object.name == "cpu":
			dialog_open = true
			dialog_just_opened = true
			dialog_text.bbcode_text = "This appears to be a cyber deck sitting on the side of the road.\nWhat do you want to do?"
			display_options()

func _process(delta):
	dialog_root.visible = dialog_open
	terminal.visible = terminal_open


func _physics_process(delta):
	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var input_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if !dialog_open and !terminal_open:
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
		
		if Input.is_action_just_pressed("action"):
			if !dialog_open:
				check_front()
	
	if dialog_open:
		handle_dialog_action()
			

func display_options():
	dialog_text.clear()
	for i in range(len(options)):
		if i == current_option_index:
			dialog_text.append_bbcode("[color=red]" + options[i] + "[/color]\n")
		else:
			dialog_text.append_bbcode(options[i] + "\n")

func handle_dialog_enter():
	
	if current_option_index == 0 :
		dialog_open = false
		dialog_just_opened = false
		
	elif current_option_index == 1 and can_pickup() :
		items.append(interaction_area.get_closest_object().name)
		interaction_area.get_closest_object().queue_free()
		dialog_open = false
		dialog_just_opened = false
		
	elif current_option_index == 2 :
		var node_name = interaction_area.get_closest_object().name
		print(node_name)
		var thing = get_node("..").get_node(node_name)
		thing.use()
		dialog_open = false
		dialog_just_opened = false
		terminal_open = true

func handle_dialog_action():
	print("doing dialog stuff")
	if dialog_open:
		print('dialog is open')
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
			if not dialog_just_opened:
				handle_dialog_enter()
				
		dialog_just_opened = false  # Reset the flag here

func play_idle_animation():
	if last_direction.y < 0:
		animation.play("idle_up")
	elif last_direction.y > 0:
		animation.play("idle_down")
	elif last_direction.x > 0:
		animation.play("idle_right")
	elif last_direction.x < 0:
		animation.play("idle_left")

