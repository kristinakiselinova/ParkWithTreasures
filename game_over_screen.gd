extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  
	await get_tree().create_timer(2.0).timeout  
	get_viewport().set_input_as_handled()  

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		queue_free()  
		get_tree().change_scene_to_file("res://main_scene.tscn")  
