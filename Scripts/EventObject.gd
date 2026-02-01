extends Area2D

@export_multiline var dialogueLine = "PLACEHOLDER"
@export_multiline var survivorSentence = "PLACEHOLDER"
@export var canLeft = false
@export var canRight = false
@export var canUp = false
@export var canDown = false

var visitedSpot = false

enum specialEvents {EVENT_NONE, EVENT_SURVIVOR, EVENT_ENTITY, 
					EVENT_SYRINGE, EVENT_INSTANTIATION, EVENT_ENTITY_FINAL, 
					EVENT_DOOR, EVENT_ENTITY_FIRST}
					
@export var curEvent = specialEvents.EVENT_NONE


# Called when the node enters the scene tree for the first time.
func _ready():
	if get_child(1) != null:
		$Cover.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func disableCover():
	$Cover.visible = false
