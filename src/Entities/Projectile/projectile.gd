extends Area2D

@export var damage = 2;
var speed = 500
var heading :Vector2 = Vector2(1.0, 0.0)
var team = ""

func _ready() -> void:
	$AnimatedSprite2D.play("throw")
	
func _physics_process(delta: float) -> void:
	position += heading.normalized() * delta * speed
	
func _on_body_entered(body: Node2D) -> void:
	if body.get("health"):
		if (body.is_in_group("enemy")) and speed > 0:
			$AnimatedSprite2D.stop()
			body.take_damage(damage)
			speed = 0
		elif (body.is_in_group("player")) and speed == 0:
			
			SignalBus.newspaper_picked_up.emit()
			self.queue_free()
			body.holding_projectile = true
	if(body.is_in_group("wall")):
		$AnimatedSprite2D.stop()
		speed = 0
