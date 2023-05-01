extends Control

onready var text_edit = $TextEdit
signal terminal_closed

# Process a command and append the output to the TextEdit node
func process_command(command):
	var output
	if is_recognized_command(command):
		if command == "exit" or command == "Exit":
			output = "Exiting terminal"
			self.visible = false
			emit_signal("terminal_closed")
		else:
			output = "Command not recognized"
	else:
		output = "Command not recognized"
	append_output_text(output)

# Called when the user presses enter
func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_ENTER:
		# Get the last line and process it as a command
		var last_line = text_edit.get_line(text_edit.get_line_count() - 1)
		process_command(last_line.strip_edges())
		# Move the cursor to the end
		text_edit.cursor_set_line(text_edit.get_line_count())

func use():
	open_terminal()

func _ready():
	pass

func open_terminal():
	self.visible = true
	var viewport_size = get_viewport_rect().size
	self.rect_position = viewport_size / 2 - self.rect_size / 2
	text_edit.grab_focus()

func is_recognized_command(command):
	# Add the recognized commands to this list
	var recognized_commands = ["exit", "Exit"]
	return command in recognized_commands

func append_output_text(text):
	text_edit.text += "\n" + text + "\n> "
	text_edit.cursor_set_line(text_edit.get_line_count() - 1)
	text_edit.cursor_set_column(text_edit.get_line(text_edit.get_line_count() - 1).length())

