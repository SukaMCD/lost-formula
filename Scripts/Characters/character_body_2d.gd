extends CharacterBody2D
class_name Player

# Movement properties
@export var speed: float = 150

# Node references
@onready var sprite = $AnimatedSprite2D
@onready var sfx_player: AudioStreamPlayer2D = $sfx_player  # Pastikan path ini sesuai dengan struktur scene kamu

# Item tracking
var collected_items: Dictionary = {}
var last_direction_x = 1
var input_enabled: bool = true

# Timer untuk mengatur jeda antara langkah-langkah
var footstep_timer: float = 0
const FOOTSTEP_DELAY: float = 0.3  # Jeda antara langkah (detik)

func _ready():
	add_to_group("player")
	process_mode = Node.PROCESS_MODE_PAUSABLE

	# Debug untuk memastikan node terhubung
	print("SFX Player node:", sfx_player)

	# Atur volume suara
	if sfx_player:
		sfx_player.volume_db = 5  # Tingkatkan volume (desibel)

func _physics_process(delta):
	if !input_enabled || get_tree().paused:
		handle_disabled_state()
		return

	var input_vector = get_input_vector()
	process_movement(input_vector)
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
	velocity = input_vector * speed
	if input_vector.x != 0:
		last_direction_x = sign(input_vector.x)

func update_animation(input_vector: Vector2):
	if input_vector.length() > 0:
		handle_moving_animations(input_vector)
	else:
		sprite.play("Idle")
		sprite.flip_h = last_direction_x < 0
		if sfx_player and sfx_player.is_playing():
			sfx_player.stop()

func handle_moving_animations(input_vector: Vector2):
	if input_vector.x != 0:
		sprite.play("Walk")
		sprite.flip_h = input_vector.x < 0
	elif input_vector.y < 0:
		sprite.play("Up")
		sprite.flip_h = last_direction_x < 0
	elif input_vector.y > 0:
		sprite.play("Down")
		sprite.flip_h = last_direction_x < 0

	# Mainkan suara langkah kaki
	play_footstep_sound()

func play_footstep_sound():
	# Kurangi timer dan mainkan suara jika timer mencapai 0
	if footstep_timer > 0:
		footstep_timer -= get_process_delta_time()
	else:
		if sfx_player and !sfx_player.playing:
			print("Memutar suara langkah kaki...")  # Debug statement
			sfx_player.play()
			footstep_timer = FOOTSTEP_DELAY  # Reset timer

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
	
	if !input_enabled || get_tree().paused:
		get_viewport().set_input_as_handled()
