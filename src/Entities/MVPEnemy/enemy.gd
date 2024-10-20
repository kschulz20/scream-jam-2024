extends CharacterBody2D

const GHOST_HEALTH = 2
const PUMPKIN_HEALTH = 4

const GHOST_MOVE_SPEED = 35
const PUMPKIN_MOVE_SPEED = 20

# By default, enemy is a ghost
@export var health = GHOST_HEALTH
@export var move_speed = GHOST_MOVE_SPEED

@export var debug_enable_move = true
@export var damage = 1

@onready var player_character = get_tree().root.find_child("PlayerCharacter", true, false)

var team = ""


func _ready() -> void:
	# For testing/debug
	set_physics_process(debug_enable_move)
	add_to_group("enemy")
	
func _physics_process(delta: float) -> void:
	velocity = move_speed * delta * (player_character.position - position)
	move_and_slide()
	#for index in get_slide_collision_count():
		#var collision := get_slide_collision(index)
		#var obj := collision.get_collider()
		#if obj == player:
			#print("gotcha!")
			
func set_type(type: String):
	match type:
		"pumpkin":
			health = PUMPKIN_HEALTH
			move_speed = PUMPKIN_MOVE_SPEED
		"ghost":
			health = GHOST_HEALTH
			move_speed = GHOST_MOVE_SPEED
		_:
			print("Enemy didn't receive a type upon instantiation")

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.get("health"):
		if (body.is_in_group("player")):
			SignalBus.player_take_damage.emit(damage)

func take_damage(damage_amount):
	health -= damage_amount
	
	if (health > 0):
		$HurtSound.play()
	elif (health <= 0):
		# hide()
		$CollisionShape2D.set_deferred("disabled", true)
		$EnemyHurtBox/CollisionShape2D.set_deferred("disabled", true)
		$EnemyHitbox/CollisionShape2D.set_deferred("disabled", true)
		$DeathSound.play()

func _on_death_sound_finished() -> void:
	call_deferred("queue_free")
