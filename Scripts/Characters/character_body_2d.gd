extends CharacterBody2D
class_name Player

# Movement properties
@export var speed: float = 150

# Node references
@onready var sprite = $AnimatedSprite2D
@onready var sfx_player: AudioStreamPlayer2D = $sfx_player

# Item tracking
var collected_items: Dictionary = {}
var last_direction_x = 1  # Default facing right
var input_enabled: bool = true

# Timer untuk mengatur jeda langkah
var footstep_timer: float = 0
const FOOTSTEP_DELAY: float = 0.3

# Cooldown serangan
var attack_cooldown: float = 0
const ATTACK_COOLDOWN_TIME: float = 0.5  # detik

# Animation state tracking
var is_attacking: bool = false
var current_animation: String = "Idle"

func _ready():
	add_to_group("player")
	process_mode = Node.PROCESS_MODE_PAUSABLE
	if sfx_player:
		sfx_player.volume_db = 5
	
	# Connect animation finished signal
	sprite.animation_finished.connect(_on_animation_finished)
	
	# Register attack input with correct case sensitivity
	if not InputMap.has_action("attack"):
		InputMap.add_action("attack")
		var event = InputEventKey.new()
		event.keycode = KEY_SPACE  # Space bar for attack
		InputMap.action_add_event("attack", event)

func _physics_process(delta):
	if !input_enabled or get_tree().paused:
		handle_disabled_state()
		return

	# Perbarui cooldown serangan
	if attack_cooldown > 0:
		attack_cooldown -= delta

	var input_vector = get_input_vector()
	
	# Always process movement to keep controls responsive
	process_movement(input_vector)
	
	# Handle animations
	update_animation(input_vector)
	
	move_and_slide()

func handle_disabled_state():
	velocity = Vector2.ZERO
	sprite.play("Idle")
	if sfx_player and sfx_player.playing:
		sfx_player.stop()

func get_input_vector() -> Vector2:
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()

func process_movement(input_vector: Vector2):
	# Always process movement input to keep controls responsive
	velocity = input_vector * speed
	if input_vector.x != 0:
		last_direction_x = sign(input_vector.x)

func update_animation(input_vector: Vector2):
	# If currently attacking, don't change animation until it's done
	if is_attacking:
		return
		
	# Check for attack input - use lowercase "attack" to match InputMap
	if Input.is_action_just_pressed("attack") and attack_cooldown <= 0:
		start_attack()
		return
	
	# Handle movement animations
	if input_vector.length() > 0:
		handle_moving_animations(input_vector)
	else:
		play_animation("Idle")
		sprite.flip_h = last_direction_x < 0  # Maintain facing direction even when idle
		if sfx_player and sfx_player.is_playing():
			sfx_player.stop()

func handle_moving_animations(input_vector: Vector2):
	if input_vector.x != 0:
		play_animation("Walk")
		sprite.flip_h = input_vector.x < 0  # Flip based on horizontal movement
	elif input_vector.y < 0:
		play_animation("Up")
		sprite.flip_h = last_direction_x < 0  # Maintain horizontal facing direction
	elif input_vector.y > 0:
		play_animation("Down")
		sprite.flip_h = last_direction_x < 0  # Maintain horizontal facing direction

	play_footstep_sound()

# Improved animation playing with state tracking
func play_animation(anim_name: String):
	if current_animation != anim_name:
		current_animation = anim_name
		sprite.play(anim_name)

# Handle attack start with proper state management
func start_attack():
	is_attacking = true
	play_animation("Attack")
	
	# Always face right during attack (flip_h = false means facing right)
	sprite.flip_h = false
	last_direction_x = 1  # Update last_direction_x to match
	
	attack_cooldown = ATTACK_COOLDOWN_TIME
	
	if sfx_player and !sfx_player.playing:
		sfx_player.play()

# Handle animation completion - this is key for smooth transitions
func _on_animation_finished():
	# If attack animation finished, immediately return to movement animation
	if current_animation == "Attack":
		is_attacking = false
		
		# Immediately check current input state and update animation
		var input_vector = get_input_vector()
		if input_vector.length() > 0:
			handle_moving_animations(input_vector)
		else:
			play_animation("Idle")
			sprite.flip_h = last_direction_x < 0  # Maintain facing direction

func play_footstep_sound():
	if footstep_timer > 0:
		footstep_timer -= get_process_delta_time()
	else:
		if sfx_player and !sfx_player.playing:
			sfx_player.play()
			footstep_timer = FOOTSTEP_DELAY

func track_item(item_id: String, quantity: int):
	if collected_items.has(item_id):
		collected_items[item_id] += quantity
	else:
		collected_items[item_id] = quantity
	print("Item terkumpul:", collected_items)

func set_input_enabled(enabled: bool):
	input_enabled = enabled
	if !enabled:
		velocity = Vector2.ZERO
		if sprite:
			sprite.stop()
		if sfx_player and sfx_player.playing:
			sfx_player.stop()

func _unhandled_input(event):
	if event.is_action_pressed("accept"):
		return
	
	if !input_enabled or get_tree().paused:
		get_viewport().set_input_as_handled()
