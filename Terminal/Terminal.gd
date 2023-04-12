extends Control

onready var text_edit = $TextEdit
onready var terminal_output = $TerminalOutput

func _ready():
	pass

func open_terminal():
	self.visible = true
	text_edit.grab_focus()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		check_command(text_edit.text)

func is_recognized_command(command):
	# Add the recognized commands to this list
	var recognized_commands = ["exit", "Exit"]
	return command in recognized_commands

func append_output_text(text):
	terminal_output.append_bbcode(text)
	terminal_output.newline()

func check_command(command):
	command = command.strip_edges()
	if is_recognized_command(command):
		if command == "exit" or command == "Exit":
			print("Exiting terminal")
			self.visible = false
	else:
		append_output_text("Command not recognized")

	text_edit.text = ""