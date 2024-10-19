extends Node

@export var enemy_scene: PackedScene
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
		var enemy = enemy_scene.instantiate()
		enemy.position = enemy_spawn.position
		enemies_node.add_child(enemy)
