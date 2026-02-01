extends Control

var curTalkString = "Move"
var gotEnding = [false, false, false, false, false]

@onready var descText = $DialogueLabel
@onready var gc = $DirectionsGridContainer
@onready var delayTimer = $TextLoadDelay
@onready var posPivot = $PositionPivot
@onready var quickTime = $QuickTimeBar
@onready var animPlayer = $AnimationPlayer
@onready var sfxPlayer = $SFXPlayer

@export var deadLol = false
@export var gotSyringe = false
@export var hasInstantiation = false
@export var hasSurivor = false
@export var manDead = false
@export var eventHappening = false
@export var canSkipText = false
@export var introPlayed = false
@export var isEscaping = false
@export var endingReached = false

@export var skipWithSpace = false
var encounteredEntity

# Called when the node enters the scene tree for the first time.
func _ready():
	print("has Instationa", hasInstantiation)
	descText.visible = false
	gcEnable(false)
	descText.changeFont(0)
	if !introPlayed:
		print("Stop")
		eventHappening = true
		animPlayer.play("IntroCutscene")
	#delayTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	posPivot.visible = gc.visible
	$TileMapLayer.visible = gc.visible
	
	if Input.is_action_just_pressed("Action") and canSkipText:
		$SpaceLabel.visible = false
		animPlayer.play()
		descText.visible = false
		canSkipText = false
	
	if Input.is_action_just_pressed("ShaderOn"):
		$CanvasLayer.visible = !$CanvasLayer.visible


func option_1_button_press():
	buttonPressed(1, Vector2.LEFT)

func option_2_button_press():
	buttonPressed(2, Vector2.RIGHT)

func option_3_button_press():
	buttonPressed(3, Vector2.UP)

func option_4_button_press():
	buttonPressed(4, Vector2.DOWN)

func buttonPressed(choice: int, dir: Vector2):
	print(posPivot.scale.y)
	descText.visible = false
	descText.text = ""
	gcEnable(false)
	posPivot.position += 24 * dir

func _on_delay_timer_timeout():
	descText.typeText(curTalkString)

func _on_text_type_complete():
	if !eventHappening:
		gcEnable(true)
	elif !introPlayed and eventHappening:
		sfxPlayer.stop()
		animPlayer.play()
		print("Hello cow")
	elif endingReached:
		sfxPlayer.stop()
		animPlayer.play()
		print("Hello cow")
	else:
		if skipWithSpace:
			$SpaceLabel.visible = true
			canSkipText = true
		else:
			animPlayer.play()

func _on_position_pivot_area_entered(area):
	if (area.get_parent().name == "CollisionBoxes" and !isEscaping) or (area.get_parent().name == "EscapeObjects" and isEscaping):
		if area.get_child(1) != null:
			area.get_child(1).visible = false
		enableDirections(area)
		specialEvent(area)
	
	print("Is escaping?", isEscaping)
	
func specialEvent(area: Area2D):
	match area.curEvent:
		area.specialEvents.EVENT_SYRINGE:
			if gotSyringe == false:
				eventHappening = true
				animPlayer.play("EventSyringe")
			else:
				defaultEvent(area)
		area.specialEvents.EVENT_INSTANTIATION:
			if hasInstantiation == false:
				$SpaceLabel.text = "[center] Press SPACE to continue"
				eventHappening = true
				canSkipText = true
				animPlayer.play("EventInstantiation")
			else:
				defaultEvent(area)
		area.specialEvents.EVENT_ENTITY_FINAL:
			eventHappening = true
			if hasInstantiation:
				$SpaceLabel.text = ""
				animPlayer.play("EventEntityConvo")
				$EntityBlinkTimer.wait_time = randi_range(3, 6)
				$EntityBlinkTimer.start()
			else:
				animPlayer.play("EndingCutscene")
			print("has Instationa", hasInstantiation)
		area.specialEvents.EVENT_ENTITY_FIRST:
			eventHappening = true
			$MusicPlayer.stop()
			$DodgeButton.randomisePosition()
			$SpaceLabel.text = ""
			animPlayer.play("EntityEncounter")
		area.specialEvents.EVENT_ENTITY:
			eventHappening = true
			$DodgeButton.randomisePosition()
			$SpaceLabel.text = ""
			animPlayer.seek(2.0)
			animPlayer.play("EntityEncounter")
		area.specialEvents.EVENT_SURVIVOR:
			if !manDead:
				eventHappening = true
				$SpaceLabel.text = "[center] Press SPACE to continue"
				animPlayer.play("SurvivorEncounter")
			else:
				defaultEvent(area)
		_:
			defaultEvent(area)
		

func defaultEvent(area: Area2D):
	if !area.visitedSpot:
		curTalkString = area.dialogueLine
		if (hasSurivor and isEscaping):
			curTalkString += area.survivorSentence
	else:
		curTalkString = "You trudge forwards. " 
		if (hasSurivor):
			curTalkString += area.survivorSentence
	area.visitedSpot = true
	delayTimer.start()

func enableDirections(area: Area2D):
	gc.get_child(0).visible = area.canLeft
	gc.get_child(1).visible = area.canRight
	#if posPivot.scale.y == 1:
	gc.get_child(2).visible = area.canUp
	gc.get_child(3).visible = area.canDown
	#else:
	#	gc.get_child(2).visible = area.canDown
	#	gc.get_child(3).visible = area.canUp

func _on_quick_timer_timeout():
	gcEnable(false)
	$MusicPlayer.stop()
	$QuickTimeBar.visible = false
	animPlayer.play("PlayerDeath")

func _on_entity_blink_timeout():
	$SkongCloseup.play("default")
	$EntityBlinkTimer.wait_time = randi_range(3, 6)
	$EntityBlinkTimer.start()

func beginEscape():
	if isEscaping == false:
		eventHappening = false
		$MusicPlayer.volume_db = -6.0
		$MusicPlayer.stream = load("res://1-2_Combat.ogg")
		$MusicPlayer.play()
		isEscaping = true

func on_do_join():
	animPlayer.play("EventEntityChoice1")

func on_do_not_join():
	animPlayer.play("EventEntityChoice2")

func gcEnable(bl: bool):
	gc.visible = bl
	$PositionPivot.visible = bl
	$TileMapLayer.visible = bl
	

func entityCheckSurvivor():
	if !hasSurivor:
		animPlayer.play("EventEntityChoice3")

func surivorCheck():
	animPlayer.pause()
	if gotSyringe:
		$SurvivorChoices2.visible = true
	else:
		$SurvivorChoices.visible = true

func giveTheMedicine():
	$SurvivorChoices.visible = false
	$SurvivorChoices2.visible = false
	animPlayer.play("SurvivorChoice2")

func askQuestion():
	$SurvivorChoices.visible = false
	$SurvivorChoices2.visible = false
	animPlayer.play("SurvivorChoice1")

func LEAVEHIMTODIE():
	animPlayer.pause()
	animPlayer.play()
	$SurvivorChoices.visible = false
	$SurvivorChoices2.visible = false

func dodge_attack():
	animPlayer.seek(10.0, true)

func loadEndScreen():
	animPlayer.play("EndingCutscene")

func restart_game():
	get_tree().reload_current_scene()

func quit_game():
	get_tree().quit()
