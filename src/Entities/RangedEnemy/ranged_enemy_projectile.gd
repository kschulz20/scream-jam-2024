extends Area2D

@export var damage = 1;
@export var speed = 300
var heading :Vector2 = Vector2(1.0, 0.0)
var team = ""

func _ready():
	add_to_group("enemy")
	$ProjectileLifetime.start()

func _physics_process(delta: float) -> void:
	position += heading.normalized() * delta * speed

func _on_body_entered(body: Node2D) -> void:
	if body.get("health"):
		if (body.is_in_group("player")):
			SignalBus.player_take_damage.emit(damage)
			call_deferred("queue_free")

func _on_projectile_lifetime_timeout() -> void:
	call_deferred("queue_free")