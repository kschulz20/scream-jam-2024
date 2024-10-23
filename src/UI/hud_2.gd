extends MarginContainer

@onready var player = get_node("/root/Main/PlayerCharacter")
@onready var score = get_node("Score")
@onready var score_counter = 0

func _ready() -> void:
	SignalBus.increase_score.connect(_on_increase_score)

func _on_increase_score() -> void:
	score_counter += 1
	score.text = "Score: " + str(score_counter)
