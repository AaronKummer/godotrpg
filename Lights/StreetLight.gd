extends Light2D

var timer = 0.0

func _ready():
	self.energy = 0;

func _process(delta):
	timer -= delta
	
	if timer <= 0:
		energy = rand_range(0.8, 1.0)
		timer = rand_range(0.05, 0.1)
		
