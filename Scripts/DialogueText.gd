extends RichTextLabel

@onready var textTypeTimer = $TextTypeTime

@export var fontNormal: FontFile
@export var fontCommand: FontFile
@export var fontDyingGuy: FontFile
@export var fontSkong: FontFile
@export var cutsceneHappening = false
@export var choiceEnabled = false
@export var shakeText = false

var centerLine = true
var currentLine = ""
var lineDisplayed = ""
var curChrInt = 0
var militaryDialogueArray = []
var survivorDialogueArray = []

var effectString = "[shake rate=25.0 level=20 connected=0] "
#var effectStringEnd = " [/shake]"

signal typeComplete

# Called when the node enters the scene tree for the first time.
func _ready():
	var md = get_parent().get_node("MilitaryDialogue")
	militaryDialogueArray.append(md.introLines)
	militaryDialogueArray.append(md.ending1Lines)
	militaryDialogueArray.append(md.ending2Lines)
	militaryDialogueArray.append(md.ending3Lines)
	militaryDialogueArray.append(md.ending4Lines)
	militaryDialogueArray.append(md.ending5Lines)
	print(militaryDialogueArray[0][0])

	var sd = get_parent().get_node("SurvivorDialogue")
	survivorDialogueArray.append(sd.survivor1Array)
	survivorDialogueArray.append(sd.survivor2Array)
	survivorDialogueArray.append(sd.survivor3Array)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#self.text = effectString + lineDisplayed + effectStringEnd
	if centerLine:
		if shakeText:
			self.text = effectString + "[center]" + lineDisplayed
		else:
			self.text = "[center]" + lineDisplayed
	else:
		self.text = lineDisplayed
	

func typeText(dglLine: String):
	print("WAIT STOP WHAT?????")
	centerLine = false
	get_parent().animPlayer.pause()
	
	currentLine = dglLine
	self.text = ""
	self.visible = true
	lineDisplayed = ""
	curChrInt = 0
	textTypeTimer.start()

func _on_text_type_time_timeout():
	lineDisplayed += currentLine[curChrInt]
	curChrInt += 1
	if curChrInt == currentLine.length():
		typeComplete.emit()
	else:
		textTypeTimer.start()

func typeTextSkong(dglLine: String):
	centerLine = true
	lineDisplayed = "[center]" + dglLine
	self.text = lineDisplayed
	self.visible = true
	if !choiceEnabled:
		get_parent().animPlayer.pause()
		typeComplete.emit()

func typeTextSurvivor(diagSetInt: int, curLineInt: int):
	lineDisplayed = ""
	curChrInt = 0
	centerLine = true
	get_parent().animPlayer.pause()
	currentLine = survivorDialogueArray[diagSetInt][curLineInt]
	print(currentLine)
	self.visible = true
	textTypeTimer.start()

func typeTextReport(diagSetInt: int, curLineInt: int):
	print("WAIT?!?!")
	centerLine = true
	get_parent().animPlayer.pause()
	currentLine += "\n" + "\n"
	currentLine += militaryDialogueArray[diagSetInt][curLineInt]
	get_parent().sfxPlayer.play(0.0)
	self.visible = true
	textTypeTimer.start()

func typeTextEnding(curLineInt: int):
	centerLine = true
	get_parent().animPlayer.pause()
	currentLine += "\n" + "\n"
	if get_parent().deadLol:
		currentLine += militaryDialogueArray[1][curLineInt]
	else:
		if get_parent().hasSurivor:
			if get_parent().hasInstantiation:
				currentLine += militaryDialogueArray[4][curLineInt]
			else:
				currentLine += militaryDialogueArray[2][curLineInt]
		else:
			if get_parent().hasInstantiation:
				currentLine += militaryDialogueArray[5][curLineInt]
			else:
				currentLine += militaryDialogueArray[3][curLineInt]
	get_parent().sfxPlayer.play(0.0)
	self.visible = true
	textTypeTimer.start()


func clearText():
	lineDisplayed = ""

func changeFont(fontType: int):
	match fontType:
		0:
			add_theme_font_override("normal_font", fontNormal)
			add_theme_font_size_override("normal_font_size", 40)
		1:
			add_theme_font_override("normal_font", fontCommand)
			add_theme_font_size_override("normal_font_size", 25)
		2:
			add_theme_font_override("normal_font", fontDyingGuy)
			add_theme_font_size_override("normal_font_size", 30)
		3:
			add_theme_font_override("normal_font", fontSkong)
			add_theme_font_size_override("normal_font_size", 30)
	
