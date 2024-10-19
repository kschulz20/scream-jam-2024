extends CharacterBody2D

@export var move_speed = 35
@export var debug_enable_move = true
@export var health = 2

@onready var player_character = get_tree().root.find_child("PlayerCharacter", true, false)

var weapon_hitbox_names = ["CaneHitbox", "PlayerProjectile"]

func _ready() -> void:
	# For testing/debug
	set_physics_process(debug_enable_move)

func take_damage():
	print("OW!!!!")
	
func _physics_process(delta: float) -> void:
	velocity = move_speed * delta * (player_character.position - position)
	move_and_slide()
	#for index in get_slide_collision_count():
		#var collision := get_slide_collision(index)
		#var obj := collision.get_collider()
		#if obj == player:
			#print("gotcha!")

# Enemy hurtbox made contact with weapon - do damage
func _on_area_entered(area: Area2D) -> void:
	if (weapon_hitbox_names.has(area.name)):
		health -= area.get_damage()
		if (health <= 0):
			queue_free()
	# TODO: HEY KYLER MAKE THE PROJECTILE DO DAMAGE
