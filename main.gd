extends Node

var time_left = 150  
var score = 0  
var win=false;

func _ready():
	$Timer.text = "Time Left: " + str(time_left)
	$Score.text = "Score: " + str(score)
	
	$Timer.set_position(Vector2(20, 20))  
	$Score.set_position(Vector2(1050, 20)) 
	start_timer()

func start_timer():
	var timer = Timer.new()
	timer.wait_time = 1.0 
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.connect("timeout", _on_timer_timeout)

func _on_timer_timeout():
	var flag = win_game()
	
	if flag == true:  
		$Timer.text = "Time Left: 0"
		win_game_print() 
		Result.score = 0; 
		return 
	
	time_left -= 1
	$Timer.text = "Time Left: " + str(time_left)

	if time_left <= 0:
		if flag == false: 
			game_over() 
		else:
			win_game_print()
			time_left = 0
			Result.score = 0
			

func add_score(value):
	score += value
	$Score.text = "Score: " + str(score)

	
func game_over():
	print("Game won!")  
	get_tree().paused = true  
	var win_game_scene = load("res://GameOverScreen.tscn").instantiate()
	get_tree().get_root().add_child(win_game_scene)
	get_tree().paused = false  
	
func win_game():
	if(Result.score == 100):
		win = true;
	else:
		win = false;
	return win;
		

func win_game_print():
	print("Game Over!") 
	get_tree().paused = true  

	var game_over_scene = load("res://WinScreen.tscn").instantiate()
	get_tree().get_root().add_child(game_over_scene)

	get_tree().paused = false
