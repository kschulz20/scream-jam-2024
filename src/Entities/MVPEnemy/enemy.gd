extends CharacterBody2D

var move_speed = 5.0

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
