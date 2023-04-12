extends KinematicBody2D

const SPEED = 80
const INTERACTION_DISTANCE = 40
var velocity = Vector2.ZERO
var last_direction = Vector2.ZERO
var cpu: Node
onready var animation = $AnimationPlayer
onready var interaction_area = $PlayerInteractionArea
onready var interaction_shape = $PlayerInteractionArea/CollisionShape2D
onready var dialogtext = $Dialog/Panel/RichTextLabel
onready var dialogbox = $Dialog
var options = ["Exit", "Pick up", "Use"]
var current_option_index = 0
var items = []

func can_pickup():
	if interaction_area.get_closest_object().name == "cpu":
		return true

func display_options():
	dialogtext.clear()
	for i in range(len(options)):
		if i == current_option_index:
			dialogtext.append_bbcode("[color=red]" + options[i] + "[/color]")
		else:
			dialogtext.append_bbcode(options[i])
		dialogtext.newline()

func open_inventory():
	print("opening inventory")
	
func open_terminal():
	print("opening terminal")
	
func check_front():
	var closest_object = interaction_area.get_closest_object()
	if closest_object:
		dialogbox.visible = true
		if closest_object.name == "cpu":
			dialogtext.append_bbcode("This appears to be a cyber deck sitting on the side of the road.")
			dialogtext.newline()
			dialogtext.append_bbcode("What do you want to do?")
			display_options()
			
func _ready():
	cpu = get_parent().get_node("cpu")

func _physics_process(delta):
	if dialogbox.visible:
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
				dialogbox.visible = false
			if current_option_index == 1:
				if can_pickup():
					items.append(interaction_area.get_closest_object().name)
					interaction_area.get_closest_object().visible = false
					dialogbox.visible = false
			if current_option_index == 2:
				var node_name = interaction_area.get_closest_object().name
				print(node_name)
				var thing = get_node("..").get_node("cpu")
				thing.use()
				dialogbox.visible = false
		
		print(items)
		
	else:
					
		if Input.is_action_just_pressed("action"):
			var thing = check_front()
			print("doing action")
		
		
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

func play_idle_animation():
	if last_direction.y < 0:
		animation.play("idle_up")
	elif last_direction.y > 0:
		animation.play("idle_down")
	elif last_direction.x > 0:
		animation.play("idle_right")
	elif last_direction.x < 0:
		animation.play("idle_left")
