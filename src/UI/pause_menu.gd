extends CanvasLayer

@onready var pause_menu = get_node("PauseMenu")
@onready var death_menu = get_node("DeathMenu")

const RUNNING = 0
const PAUSED = 1
const DEAD = 2
var menu_state = PAUSED

func restart():
	unpause()
	get_tree().reload_current_scene()

func pause():
	get_tree().paused = true
	pause_menu.show()
	death_menu.hide()
	menu_state = PAUSED
	
func unpause():
	get_tree().paused = false
	pause_menu.hide()
	death_menu.hide()
	menu_state = RUNNING

func death():
	get_tree().paused = true
	pause_menu.hide()
	death_menu.show()
	menu_state = DEAD

func _process(delta: float) -> void:
	if (Input.is_action_just_pressed("restart")):
		restart()
	if (Input.is_action_just_pressed("toggle_menu")):
		if get_tree().paused:
			unpause()
		else:
			pause()


#region Pause Menu buttons
func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/UI/main_menu.tscn")


func _on_restart_pressed() -> void:
	restart()


func _on_continue_pressed() -> void:
	unpause()

#endregion


func _on_player_character_death() -> void:
	print("we dead :(")
	death()
