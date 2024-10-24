extends CharacterBody2D

@export var move_speed :float = 1600.0
@export var health = 3
@export var projectile :PackedScene = load(
	"res://src/Entities/Projectile/projectile.tscn"
)

@export var fire_rate :float = 1.5
var last_projectile_fired :float = 0.0
var is_firing = false
var holding_projectile = true

@export var melee_rate :float = 1.0
var last_melee :float = 0.0

var player_hitboxes_to_ignore = ["PlayerProjectile", "CaneHitbox"]
var enemy_hitbox_types = ["MVPEnemyHitbox"]

var unconditional_voiceline_chance = 25
var enemy_detected_voiceline_chance = 10
var newspaper_voiceline_chance = 20

var player_died = false
signal death

var is_mouse_input = false
signal cane_attack(cane_hitbox_vector: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_take_damage.connect(_on_player_take_damage)
	SignalBus.witch_moving_toward_player.connect(_on_witch_moving_toward_player)
	SignalBus.ghost_moving_toward_player.connect(_on_ghost_moving_toward_player)
	SignalBus.newspaper_picked_up.connect(_on_newspaper_picked_up)
	
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
	var is_walking = false
	if (velocity.length() == 0):
		$AnimatedSprite2D.animation = "idle"
	if (velocity.length() > 0):
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.flip_h = velocity.x > 0
	# check for death
	if (health <= 0):
		# hide() # Player disappears after being hit.
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.animation = "death"
		player_died = true
		death.emit()
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
	
	if (not player_died):
		last_melee = clamp(last_melee - delta, 0.0, INF)
		last_projectile_fired = clamp(last_projectile_fired - delta, 0.0, INF)
		if (Input.is_action_just_pressed("cane_attack")):
			if last_melee <= 0.0:
				melee(aim_dir)
				last_melee = 1.0 / melee_rate
		elif (Input.is_action_just_pressed("range_attack")):
			is_firing = true
		if (Input.is_action_just_released("range_attack")):
			is_firing = false
		if is_firing and last_projectile_fired <= 0.0 and holding_projectile:
			shoot(aim_dir)
			last_projectile_fired = 1.0 / (fire_rate)
			holding_projectile = false

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
		
func melee(aim_dir :Vector2):
	var mouse_angle: float = aim_dir.angle()
	var cane_hitbox_vector: Vector2 = Vector2.from_angle(mouse_angle)
	# multiply by some amount here
	cane_attack.emit(cane_hitbox_vector)
	
func shoot(dir: Vector2):
	var new_projectile = projectile.instantiate()
	new_projectile.heading = dir
	new_projectile.position = self.position  + (dir * 1.2)
	new_projectile.team = "player"
	owner.add_child(new_projectile)
	
	if (not is_voiceline_playing()):
		if (randi() % 100 <= newspaper_voiceline_chance):
			$Voicelines/NewspaperSound.play()

func is_voiceline_playing():
	var voicelines = $Voicelines.get_children()
	
	var is_playing = false
	for sound in voicelines:
		if (sound.is_playing()):
			is_playing = true
	return is_playing

func _on_player_take_damage(damage_amount):
	health -= damage_amount
	LivesCounter.lives -= 1
	if (health <= 0):
		$Sounds/DeathSound.play()
	else:
		$Sounds/HurtSound.play()
		$Sounds/OwSound.play()

# Voicelines randomly said regardless of what's happening
func _on_voiceline_timer_timeout() -> void:
	if (randi() % 100 <= unconditional_voiceline_chance):
		var voiceline = randi() % 3
		if (not is_voiceline_playing()):
			match voiceline:
				0:
					$Voicelines/TreatsSound.play()
				1:
					$Voicelines/TricksSound.play()
				2:
					$Voicelines/LawnSound.play()

func play_enemy_detected_voiceline(sound) -> void:
		if (not is_voiceline_playing()):
			if (randi() % 100 <= enemy_detected_voiceline_chance):
				sound.play()

# "I'll knock that witch hat right off ya" voiceline logic
func _on_witch_moving_toward_player() -> void:
	play_enemy_detected_voiceline($Voicelines/WitchSound)

func _on_ghost_moving_toward_player() -> void:
	play_enemy_detected_voiceline($Voicelines/GhostSound)
	
func _on_newspaper_picked_up() -> void:
	$Sounds/NewspaperPickupSound.play()
