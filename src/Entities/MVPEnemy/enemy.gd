extends CharacterBody2D

const GHOST_HEALTH = 4
const PUMPKIN_HEALTH = 6

const GHOST_MOVE_SPEED = 40
const PUMPKIN_MOVE_SPEED = 20
const GHOST_RANGE = 400
const random_direction_freq = 200
const random_stop_movement_freq = 100
# By default, enemy is a ghost
@export var health = GHOST_HEALTH
@export var move_speed = GHOST_MOVE_SPEED
@export var enemy_range = GHOST_RANGE
@export var debug_enable_move = true
@export var damage = 1

@onready var player_character = get_tree().root.find_child("PlayerCharacter", true, false)

var sprite
var is_ghost = false
var detected_for_first_time = false
var team = ""
var random_direction = Vector2.ZERO
var curr_move_speed = null
var curr_direction = null
func _ready() -> void:
	# For testing/debug
	set_physics_process(debug_enable_move)
	add_to_group("enemy")
	
func _physics_process(delta: float) -> void:
	# if player position is too far, move in a random direction
	if player_character.position.distance_to(position) > enemy_range:
		if randi() % random_direction_freq == 0 or random_direction == Vector2.ZERO:
			curr_move_speed = 20
			random_direction = Vector2(randi_range(-200,200), randi_range(-200,200))
		# ! Uncomment below if you want the enemy to randomly stop moving. !
		#if randi() % random_stop_movement_freq == 0: 
			#curr_move_speed = 0
		curr_direction = random_direction
	else:
		curr_move_speed = move_speed
		curr_direction = (player_character.position - position) 
		
		# Ghost voiceline
		if (is_ghost):
			if (not detected_for_first_time):
				SignalBus.ghost_moving_toward_player.emit()
				detected_for_first_time = true
	velocity = curr_move_speed * delta * curr_direction
	
	sprite.play()
	sprite.flip_h = velocity.x > 0
	
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
			
			sprite = $PumpkinSprite
			sprite.visible = true
			$GhostSprite.visible = false
		"ghost":
			health = GHOST_HEALTH
			move_speed = GHOST_MOVE_SPEED
			
			sprite = $GhostSprite
			sprite.visible = true
			$PumpkinSprite.visible = false
			
			is_ghost = true
		_:
			print("Enemy didn't receive a type upon instantiation")

func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.get("health"):
		if (body.is_in_group("player")):
			SignalBus.player_take_damage.emit(damage)

func take_damage(damage_amount):
	health -= damage_amount
	
	if (health > 0):
		$Sounds/HurtSound.play()
	elif (health <= 0):
		sprite.visible = false
		$Poof.visible = true
		$AnimationPlayer.play("poof")
		$CollisionShape2D.set_deferred("disabled", true)
		$EnemyHurtBox/CollisionShape2D.set_deferred("disabled", true)
		$EnemyHitbox/CollisionShape2D.set_deferred("disabled", true)
		$Sounds/DeathSound.play()

func _on_death_sound_finished() -> void:
	call_deferred("queue_free")
