extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ShaderOn"):
		$CanvasLayer.visible = !$CanvasLayer.visible

func _on_button_down():
	#get_tree().quit()
	get_tree().change_scene_to_file("res://MainScene.tscn")
	pass # Replace with function body.
