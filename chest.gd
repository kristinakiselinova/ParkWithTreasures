extends Area3D

@onready var score_label=$"../Score"

func _process(delta: float):
	rotate_y(0.03)
	
func _on_body_entered(body):
	Result.score += 10
	update_score_label()
	queue_free()
	$MeshInstance3D.queue_free()
	
func update_score_label():
	if score_label:
		score_label.text="Score: " + str(Result.score)
