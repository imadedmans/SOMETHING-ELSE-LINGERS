extends ProgressBar
#REMEMBER TO SWITCH TO TEXTUREPROGRESSBAR LATER 
@onready var timerC = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = (timerC.time_left / timerC.wait_time) * 100.0

func startQuickTime(st: bool):
	$Timer.wait_time = 1.4 if get_parent().hasSurivor else 2.0
	
	if st:
		$Timer.start()
	else:
		$Timer.stop()

func stopTimer():
	$Timer.stop()
