extends Node

@export var mvp_enemy_scene = load("res://src/Entities/MVPEnemy/enemy.tscn")
@export var ranged_enemy_scene = load("res://src/Entities/RangedEnemy/ranged_enemy.tscn")
@onready var enemies_node = get_tree().root.find_child("Enemies", true, false)
var enemy_spawn_list

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EnemySpawnTimer.start()
	enemy_spawn_list = [$EnemySpawn1, $EnemySpawn2]
	# Ensure enemies spawn at game start
	_on_enemy_spawn_timer_timeout()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_enemy_spawn_timer_timeout() -> void:
	for enemy_spawn in enemy_spawn_list:
		var enemy
		
		if (randi() % 3 == 0):
			enemy = ranged_enemy_scene.instantiate()
		else:
			enemy = mvp_enemy_scene.instantiate()
			if (randi() % 2 == 0):
				enemy.set_type("pumpkin")
			else:
				enemy.set_type("ghost")
		
		enemy.position = enemy_spawn.position
		enemies_node.add_child(enemy)
