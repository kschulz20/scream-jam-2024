extends MarginContainer

@onready var player = get_node("/root/Main/PlayerCharacter")
@onready var health = get_node("Health")

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	health.text = "Health: " + str(player.health)
