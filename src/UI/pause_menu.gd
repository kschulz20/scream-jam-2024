extends CanvasLayer

func restart():
	hide()
	get_tree().paused = false
	get_tree().reload_current_scene()

func pause():
	get_tree().paused = true
	show()
	
func unpause():
	get_tree().paused = false
	hide()

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("restart")):
		restart()
	if (Input.is_action_just_pressed("toggle_menu")):
		if get_tree().paused:
			unpause()
		else:
			pause()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/UI/main_menu.tscn")


func _on_restart_pressed() -> void:
	restart()


func _on_continue_pressed() -> void:
	unpause()
	
