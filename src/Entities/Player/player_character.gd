extends CharacterBody2D

@export var move_speed :float = 1600.0
@export var health = 1
@export var projectile :PackedScene = load(
	"res://src/Entities/Projectile/projectile.tscn"
)

@export var fire_rate :float = 1.5
var last_projectile_fired :float = 0.0
var is_firing = false

var player_hitboxes_to_ignore = ["PlayerProjectile", "CaneHitbox"]
var enemy_hitbox_types = ["MVPEnemyHitbox"]

var player_died = false

var is_mouse_input = false
signal cane_attack(cane_hitbox_vector: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	# determine aiming input device
	if event is InputEventMouseMotion:
		is_mouse_input = true
	if event is InputEventJoypadMotion:
		is_mouse_input = false
		#
			## aim input
	#var aim_dir :Vector2 = Vector2(0.0, 0.0)
	#if is_mouse_input:
		#var mouse_position :Vector2 = self.get_local_mouse_position()
		#aim_dir = mouse_position.normalized()
	#else:
		#aim_dir	= Input.get_vector(
			#"aim_left", "aim_right",
			#"aim_up", "aim_down"
		#).normalized()
	#
	#if is_mouse_input:
		## print("mouse aim: " + str(aim_dir))
		#pass
	#else:
		## print("controller aim: " + str(aim_dir))
		#pass
#
	#if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		#var mouse_angle: float = aim_dir.angle()
		#var cane_hitbox_vector: Vector2 = Vector2.from_angle(mouse_angle)
		## multiply by some amount here
		#cane_attack.emit(cane_hitbox_vector)

func _process(delta: float) -> void:
	# check for death
	if (health <= 0):
		hide() # Player disappears after being hit.
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
		player_died = true
	# aim input
	var aim_dir :Vector2 = Vector2(0.0, 0.0)
	if is_mouse_input:
		var mouse_position :Vector2 = self.get_local_mouse_position()
		aim_dir = mouse_position.normalized()
	else:
		aim_dir	= Input.get_vector(
			"aim_left", "aim_right",
			"aim_up", "aim_down"
		).normalized()
	
	if is_mouse_input:
		# print("mouse aim: " + str(aim_dir))
		pass
	else:
		# print("controller aim: " + str(aim_dir))
		pass

	if (Input.is_action_just_pressed("cane_attack")):
		var mouse_angle: float = aim_dir.angle()
		var cane_hitbox_vector: Vector2 = Vector2.from_angle(mouse_angle)
		# multiply by some amount here
		cane_attack.emit(cane_hitbox_vector)
	elif (Input.is_action_just_pressed("range_attack")):
		is_firing = true
	if (Input.is_action_just_released("range_attack")):
		is_firing = false
		
	var has_fired = false
	if is_firing:
		if last_projectile_fired <= 0.0:
			shoot(aim_dir)
			last_projectile_fired = 1.0 / (fire_rate)
			has_fired = true
	if not has_fired:
		last_projectile_fired -= delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (not player_died):
		# movement input
		var vel_dir :Vector2 = Input.get_vector(
			"move_left", "move_right",
			"move_up", "move_down"
		).normalized()
		
		# handle movement
		velocity = move_speed * delta * vel_dir;
		move_and_slide()
		
		# TODO: do something with aim direction
	
func shoot(dir: Vector2):
	var new_projectile = projectile.instantiate()
	new_projectile.heading = dir
	new_projectile.position = self.position + (dir * 1.2)
	new_projectile.team = "player"
	owner.add_child(new_projectile)
