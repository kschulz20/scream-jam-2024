extends Area2D

@export var damage = 1;
var speed = 2000
var heading :Vector2 = Vector2(1.0, 0.0)
var team = ""

func _physics_process(delta: float) -> void:
	position += heading.normalized() * delta * speed

func get_damage():
	return damage

func _on_body_entered(body: Node2D) -> void:
	if body.get("health"):
		if (not body.is_in_group(team) and not body.is_in_group("player")):
			body.health -= damage
			self.queue_free()
