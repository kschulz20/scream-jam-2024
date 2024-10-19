extends CharacterBody2D

@export var move_speed = 35
@export var debug_enable_move = true

func _ready() -> void:
	# For testing/debug
	set_physics_process(debug_enable_move)	

func take_damage():
	print("OW!!!!")
	
func _physics_process(delta: float) -> void:
	velocity = move_speed * delta * (%PlayerCharacter.position - position)
	move_and_slide()
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var obj := collision.get_collider()
		if obj == %PlayerCharacter:
			print("gotcha!")
