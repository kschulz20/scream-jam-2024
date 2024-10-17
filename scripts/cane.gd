extends Node2D

@onready var _animation_player = $AnimationPlayer
@onready var cane_sprite = $CaneSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (not _animation_player.is_playing()):
		cane_sprite.visible = false

func _on_player_character_cane_attack() -> void:
	cane_sprite.visible = true
	_animation_player.play("cane_attack")
