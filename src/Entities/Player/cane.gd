extends Node2D

@export var CANE_HITBOX_DISTANCE_FROM_PLAYER: float = 170
@onready var _animation_player = $AnimationPlayer
@onready var cane_sprite = $CaneSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (not _animation_player.is_playing()):
		cane_sprite.visible = false

func _on_player_character_cane_attack(cane_hitbox_vector: Vector2) -> void:
	# Distance cane attack sprite away from player
	cane_sprite.position = cane_hitbox_vector * CANE_HITBOX_DISTANCE_FROM_PLAYER
	# Change animation direciton of cane attack based on where mouse is
	cane_sprite.set_flip_v(cane_hitbox_vector.x < 0)
	# Rotate cane sprite attack based off where player clicked
	cane_sprite.rotation = cane_hitbox_vector.angle()
	
	cane_sprite.visible = true
	_animation_player.play("cane_attack")
