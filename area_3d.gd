extends Area3D  

signal item_collected

func _ready():
	add_to_group("chests")  
	connect("body_entered", Callable(self, "_on_body_entered")) 

func _on_body_entered(body):
	print("Collision detected with:", body) 
	if body.is_in_group("player"):  
		print("Chest collected!")  
		emit_signal("item_collected")  
		queue_free()  
