extends CharacterBody2D

@export var move_speed :float = 1600.0

var is_mouse_input = false
signal cane_attack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	# determine aiming input device
	if event is InputEventMouseMotion:
		is_mouse_input = true
	if event is InputEventJoypadMotion:
		is_mouse_input = false

func _process(delta: float) -> void:
	if (Input.is_action_pressed("cane_attack")):
		cane_attack.emit()

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
		# print("mouse aim: " + str(aim_dir))
		pass
	else:
		# print("controller aim: " + str(aim_dir))
		pass
		
	
	# handle movement
	velocity = move_speed * delta * vel_dir;
	move_and_slide()
	
	# TODO: do something with aim direction
