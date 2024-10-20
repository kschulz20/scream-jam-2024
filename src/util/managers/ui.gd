extends Node

# Define components.
@onready var g_StatusElement : Label = get_node("UI/Status")

func _ready() -> void:
	SignalBus.update_status_text.connect(on_status_update)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_status_update(new_text):
	print(new_text)
