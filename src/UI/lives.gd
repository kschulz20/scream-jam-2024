extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LivesCounter.lives = 3


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if LivesCounter.lives == 2:
		$Life3.hide()
	if LivesCounter.lives == 1:
		$Life2.hide()
	#if LivesCounter.lives == 0:
		#$Life1.hide()
