extends TextureButton

@export var minPos = Vector2(-540, -228)
@export var maxPos = Vector2(12, 204)
@export var shakeHor = true
@export var shakeVert = true

var curPosition

# Called when the node enters the scene tree for the first time.
func _ready():
	curPosition = self.position
	pass # Replace with function body.

func randomisePosition():
	self.position.x = randf_range(minPos.x, maxPos.x)
	self.position.y = randf_range(minPos.y, maxPos.y)
	curPosition = self.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shakeHor:
		self.position.x = randf_range(curPosition.x - 10, curPosition.x + 10)
	if shakeVert:
		self.position.y = randf_range(curPosition.y - 10, curPosition.y + 10)
