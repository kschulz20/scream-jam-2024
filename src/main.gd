extends Node

var g_UINode 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UISignalBus.update_faint_counter.emit("YOOO")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	UISignalBus.update_faint_counter.emit("YOOO")

func _on_general_enemy_killed() -> void:
	pass # Replace with function body.
