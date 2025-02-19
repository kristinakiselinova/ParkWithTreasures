extends CharacterBody3D

const SPEED = 13.0
const JUMP_VELOCITY = 15.0
const MOUSE_SENSITIVITY = 0.002
const ROTATION_SPEED = 10.0  
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera = $Camera3D
@onready var camera_pivot = $CameraPivot
@onready var mesh = $MeshInstance3D  
@onready var score_label = get_node("Score")
var score = 0

func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if !camera_pivot:
		var pivot = Node3D.new()
		pivot.name = "CameraPivot"
		add_child(pivot)
		camera_pivot = pivot
		
		if camera:
			camera.get_parent().remove_child(camera)
			pivot.add_child(camera)
			camera.position = Vector3(0, 22.0, 0)

	var chests = get_tree().get_nodes_in_group("chests")

	for chest in chests:
		if chest.has_signal("item_collected"):
			chest.connect("item_collected", Callable(self, "_on_item_collected"))


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var camera_basis = camera_pivot.global_transform.basis
	var direction = camera_basis * Vector3(input_dir.x, 0, input_dir.y)
	direction.y = 0
	direction = direction.normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		var target_rotation = atan2(direction.x, direction.z)
		
		var current_rotation = mesh.rotation.y
		var rotation_diff = wrapf(target_rotation - current_rotation, -PI, PI)
		mesh.rotation.y = current_rotation + rotation_diff * ROTATION_SPEED * delta
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			camera_pivot.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
			var camera_rot = camera.rotation.x - event.relative.y * MOUSE_SENSITIVITY
			camera.rotation.x = clamp(camera_rot, -PI/2, PI/2)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
func _on_item_collected():
	print("Item collected signal received!") 
	score += 10  
	update_score_display() 

func update_score_display():
	score_label.text = "Score: " + str(score)

	
	
