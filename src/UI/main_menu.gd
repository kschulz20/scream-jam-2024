extends Control

@onready var play_button = get_node("VBoxContainer/MenuOptions/Play")

func _ready():
	play_button.grab_focus()

func _on_play_pressed() -> void:
	print('play!')
	get_tree().change_scene_to_file("res://src/main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
