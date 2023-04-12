extends Control

var input: LineEdit
var output: RichTextLabel
var prompt: Label

func _ready():
	input = $Input
	output = $Output
	prompt = $Prompt
	input.connect("text_changed", self, "_on_text_changed")
	output.bbcode_enabled = true
	output.append_bbcode("[color=aqua]>[/color] ")
	prompt.text = "C:\\>"
	input.grab_focus()

func _on_text_changed():
	var text = input.text
	if text != "":
		output.append_bbcode(prompt.text + " " + text + "\n")
		input.clear()

func _input(event):
	if event is InputEventKey:
		if event.pressed && event.scancode == KEY_ENTER:
			_on_text_changed()
			return true
	var parent = get_parent()
	if parent is Control:
		parent._input(event)
	return false
