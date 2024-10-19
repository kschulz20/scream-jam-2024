extends Area2D

@export var damage = 1;
var speed = 2000
var heading :Vector2 = Vector2(1.0, 0.0)

func _physics_process(delta: float) -> void:
	position += heading * delta * speed

func get_damage():
	return damage
