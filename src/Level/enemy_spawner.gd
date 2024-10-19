extends Node2D

signal spawn_enemy()

func _ready():
	var main = get_node("Main")
	

func _on_spawn_timer_timeout() -> void:
	spawn_enemy.emit()
