extends Area2D

@export var damage = 1;
var speed = 2000
var heading :Vector2 = Vector2(1.0, 0.0)
var team = ""

func _physics_process(delta: float) -> void:
	position += heading.normalized() * delta * speed

func _on_body_entered(body: Node2D) -> void:
	if body.get("health"):
		if (body.is_in_group("enemy")):
			body.take_damage(damage)
			self.queue_free()
