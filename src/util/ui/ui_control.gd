extends Node
 
func _on_ui_update_faint_counter(new_text: String) -> void:
	if $'FaintCounter' != null:
		$'FaintCounter'.text = new_text
