extends CharacterBody2D
class_name Player

# === Movement ===
@export var speed: float = 150

# === Health ===
@export var max_health: int = 100
var current_health: int = max_health
var is_dead: bool = false

# === Node References ===
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_player: AudioStreamPlayer2D = $sfx_player

# === Input & State ===
var input_enabled: bool = true
var is_attacking: bool = false
var current_animation: String = "Idle"
var last_direction_x: int = 1  # Default facing right

# === Timers ===
var footstep_timer: float = 0.0
const FOOTSTEP_DELAY: float = 0.3

var attack_cooldown: float = 0.0
const ATTACK_COOLDOWN_TIME: float = 0.5

# === Inventory / Tracking ===
var collected_items: Dictionary = {}

# === READY ===
func _ready():
	add_to_group("player")
	process_mode = Node.PROCESS_MODE_PAUSABLE

	if sfx_player:
		sfx_player.volume_db = 5

	sprite.animation_finished.connect(_on_animation_finished)

	# Setup attack input if missing
	if not InputMap.has_action("attack"):
		var event := InputEventKey.new()
		event.keycode = KEY_K
		InputMap.add_action("attack")
		InputMap.action_add_event("attack", event)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dialog"):
		DialogueManager.show_example_dialogue_balloon(load("res://addons/arahan.dialogue"))
		return
		
# === PHYSICS LOOP ===
func _physics_process(delta: float) -> void:
	if !input_enabled or get_tree().paused:
		handle_disabled_state()
		return

	if attack_cooldown > 0:
		attack_cooldown -= delta

	var input_vector := get_input_vector()
	process_movement(input_vector)
	update_animation(input_vector)
	move_and_slide()

# === INPUT ===
func get_input_vector() -> Vector2:
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()

# === MOVEMENT ===
func process_movement(input_vector: Vector2) -> void:
	velocity = input_vector * speed
	if input_vector.x != 0:
		last_direction_x = sign(input_vector.x)

# === ANIMATION ===
func update_animation(input_vector: Vector2) -> void:
	if is_attacking:
		return

	if Input.is_action_just_pressed("attack") and attack_cooldown <= 0:
		start_attack()
		return

	if input_vector.length() > 0:
		handle_moving_animations(input_vector)
	else:
		play_animation("Idle")
		sprite.flip_h = last_direction_x < 0
		if sfx_player and sfx_player.is_playing():
			sfx_player.stop()

func handle_moving_animations(input_vector: Vector2) -> void:
	if input_vector.x != 0:
		play_animation("Walk")
		sprite.flip_h = input_vector.x < 0
	elif input_vector.y < 0:
		play_animation("Up")
		sprite.flip_h = last_direction_x < 0
	elif input_vector.y > 0:
		play_animation("Down")
		sprite.flip_h = last_direction_x < 0

	play_footstep_sound()

func play_animation(anim_name: String) -> void:
	if current_animation != anim_name:
		current_animation = anim_name
		sprite.play(anim_name)

func _on_animation_finished() -> void:
	if current_animation == "Attack":
		is_attacking = false
		var input_vector := get_input_vector()
		if input_vector.length() > 0:
			handle_moving_animations(input_vector)
		else:
			play_animation("Idle")
			sprite.flip_h = last_direction_x < 0

# === ATTACK ===
func start_attack():
	if is_attacking:
		return

	is_attacking = true
	play_animation("Attack")

	# Flip sprite sesuai arah terakhir
	sprite.flip_h = last_direction_x < 0

	attack_cooldown = ATTACK_COOLDOWN_TIME

	if sfx_player and !sfx_player.playing:
		sfx_player.play()

# === FOOTSTEPS ===
func play_footstep_sound() -> void:
	if footstep_timer > 0:
		footstep_timer -= get_process_delta_time()
	else:
		if sfx_player and !sfx_player.playing:
			sfx_player.play()
			footstep_timer = FOOTSTEP_DELAY

# === DISABLED STATE ===
func handle_disabled_state() -> void:
	velocity = Vector2.ZERO
	sprite.play("Idle")
	if sfx_player and sfx_player.playing:
		sfx_player.stop()

# === DAMAGE & DEATH ===
func take_damage(amount: int) -> void:
	if is_dead:
		return

	current_health -= amount
	print("Player HP:", current_health)

	if current_health <= 0:
		die()

func die() -> void:
	is_dead = true
	input_enabled = false
	velocity = Vector2.ZERO
	sprite.play("Death")
	print("Player is dead!")

# === INVENTORY ===
func track_item(item_id: String, quantity: int) -> void:
	collected_items[item_id] = collected_items.get(item_id, 0) + quantity
	print("Item terkumpul:", collected_items)

# === INPUT CONTROL ===
func set_input_enabled(enabled: bool) -> void:
	input_enabled = enabled
	if !enabled:
		velocity = Vector2.ZERO
		sprite.stop()
		if sfx_player and sfx_player.playing:
			sfx_player.stop()
