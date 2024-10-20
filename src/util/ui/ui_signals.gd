extends Node

# Signal for the faint counter.
signal update_faint_counter(new_text: String)

func _ready() -> void:
	# Connect all signals.
	UISignalBus.update_faint_counter.connect(UIManager._on_ui_update_faint_counter)
