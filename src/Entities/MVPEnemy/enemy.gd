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

@export var projectile :PackedScene = load(
	"res://src/Entities/Projectile/projectile.tscn"
)

@onready var player_character = get_tree().root.find_child("PlayerCharacter", true, false)

var team = ""


func _ready() -> void:
	# For testing/debug
	set_physics_process(debug_enable_move)
	add_to_group("enemy")
	
func _process(_delta: float) -> void:
	# shoot(0)
	if (health <= 0):
		call_deferred("queue_free")
	
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

func shoot(damage :int):
	var new_projectile = projectile.instantiate()
	new_projectile.heading = (player_character.position - position)
	new_projectile.position = position
	new_projectile.team = "enemy"
	new_projectile.damage = damage
	add_sibling(new_projectile)


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.get("health"):
		if (body.is_in_group("player")):
			body.health -= damage
