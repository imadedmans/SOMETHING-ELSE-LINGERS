extends AnimatedSprite2D

@export var shakeHor = true

var curPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	curPosition = self.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shakeHor:
		self.position.x = randf_range(curPosition.x - 10, curPosition.x + 10)
