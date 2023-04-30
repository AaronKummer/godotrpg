extends StaticBody2D


func use():
	var terminal = get_parent().get_parent().get_node("DialogCanvasLayer/Terminal")
	terminal.use()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
