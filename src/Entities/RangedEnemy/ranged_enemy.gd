extends CharacterBody2D

const random_direction_freq = 200
const random_stop_movement_freq = 100
@export var health = 2
@export var move_speed = 30 # 15
@export var enemy_detection_range = 500
@export var enemy_firing_range = 325
@export var projectile: PackedScene
@export var projectile_frequency = 100 #650
@export var fire_rate: float = 1.25
@export var damage = 1

@onready var player_character = get_tree().root.find_child("PlayerCharacter", true, false)

var last_projectile_fired: float = 0.0
var is_firing = false
var dist_from_player = INF
var team = ""
var random_direction = Vector2.ZERO
var curr_move_speed = null
var curr_direction = null


func _ready() -> void:
	add_to_group("enemy")
	$AnimationPlayer.play("walk")
	
func _process(_delta: float) -> void:
	var has_fired = false
	if last_projectile_fired <= 0.0:
		if (randi() % projectile_frequency == 0) and dist_from_player < enemy_firing_range:
			$AnimationPlayer.play("attack")
			shoot(damage)
			last_projectile_fired = 1.0 / (fire_rate)
			has_fired = true
	if not has_fired:
		last_projectile_fired -= _delta
	
func _physics_process(delta: float) -> void:
	dist_from_player = player_character.position.distance_to(position)
	if dist_from_player > enemy_detection_range:
		if randi() % random_direction_freq == 0 or random_direction == Vector2.ZERO:
			curr_move_speed = 20
			random_direction = Vector2(randi_range(-200,200), randi_range(-200,200))
		curr_direction = random_direction		
	elif dist_from_player < enemy_firing_range:
		curr_move_speed = 0
	else:
		curr_move_speed = move_speed
		curr_direction = (player_character.position - position) 
	velocity = curr_move_speed * delta * curr_direction
	$Sprite2D.flip_h = velocity.x > 0
	move_and_slide()

			
func shoot(damage: int):
	is_firing = true
	
	var new_projectile = projectile.instantiate()
	new_projectile.heading = (player_character.position - position)
	new_projectile.position = position
	new_projectile.team = "enemy"
	new_projectile.damage = damage
	add_sibling(new_projectile)
	$ProjectileSound.play()

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.get("health"):
		if (body.is_in_group("player")):
			SignalBus.player_take_damage.emit(damage)

func take_damage(damage_amount):
	health -= damage_amount
	
	if (health > 0):
		$HurtSound.play()
	elif (health <= 0):
		hide()
		$CollisionShape2D.set_deferred("disabled", true)
		$RangedEnemyHurtBox/CollisionShape2D.set_deferred("disabled", true)
		$RangedEnemyHitbox/CollisionShape2D.set_deferred("disabled", true)
		$DeathSound.play()

func _on_death_sound_finished() -> void:
	call_deferred("queue_free")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "attack"):
		$AnimationPlayer.play("walk")
