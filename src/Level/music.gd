extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var theme = "LevelTheme" + str(((randi() % 2) + 1))
	var level_music = get_tree().root.find_child(theme, true, false)
	level_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
