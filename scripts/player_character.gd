extends CharacterBody2D

var move_speed :float = 2.0

var is_mouse_input = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _input(event: InputEvent) -> void:
	# determine aiming input device
	if event is InputEventMouseMotion:
		is_mouse_input = true
	if event is InputEventJoypadMotion:
		is_mouse_input = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# movement input
	var vel_dir :Vector2 = Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down"
	).normalized()
	# aim input
	var aim_dir :Vector2 = Vector2(0.0, 0.0)
	if is_mouse_input:
		var mouse_position :Vector2 = self.get_local_mouse_position()
		aim_dir = mouse_position.normalized()
	else:
		aim_dir	= Input.get_vector(
			"aim_left", "aim_right",
			"aim_up", "aim_down"
		).normalized()
	
	if is_mouse_input:
		print("mouse aim: " + str(aim_dir))
	else:
		print("controller aim: " + str(aim_dir))
	# handle movement
	velocity = move_speed * delta * vel_dir;
	move_and_slide()
	
	# TODO: do something with aim direction
