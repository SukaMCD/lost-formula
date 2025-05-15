extends CharacterBody2D
class_name Player

# === Movement ===
@export var speed: float = 150

# === Health ===
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

# === Node References ===
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_player: AudioStreamPlayer2D = $sfx_player
@onready var attack_hitbox: Area2D = $AttackHitbox  # Dapatkan referensi ke AttackHitbox

# === Input & State ===
var input_enabled: bool = true
var is_attacking: bool = false
var current_animation: String = "Idle"
var last_direction_x: int = 1    # Default facing right

# === Timers ===
var footstep_timer: float = 0.0
const FOOTSTEP_DELAY: float = 0.3

var attack_cooldown: float = 0.0
const ATTACK_COOLDOWN_TIME: float = 0.5
const ATTACK_DAMAGE: int = 20 # Tambahkan konstanta untuk damage

# === Inventory / Tracking ===
var collected_items: Dictionary = {}

# === Sinyal ===
signal attack_hit(target, damage) # Sinyal untuk memberi tahu ketika serangan mengenai sesuatu

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

	# Pastikan AttackHitbox ada
	if not attack_hitbox:
		printerr("Error: AttackHitbox node not found!  Make sure you have an Area2D named AttackHitbox as a child of the Player node.")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dialog"):
		DialogueManager.show_example_dialogue_balloon(load("res://addons/arahan.dialogue"))
		return
		
# === PHYSICS LOOP ===
func _physics_process(delta: float) -> void:
	enemy_attack()
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
		# Nonaktifkan hitbox setelah animasi selesai
		if attack_hitbox:
			attack_hitbox.monitoring = false
			attack_hitbox.disconnect("area_entered", _on_attack_hit_area_entered) # Disconnect signal
		var input_vector := get_input_vector()
		if input_vector.length() > 0:
			handle_moving_animations(input_vector)
		else:
			play_animation("Idle")
			sprite.flip_h = last_direction_x < 0

# === ATTACK ===
func start_attack():
	if is_attacking or attack_cooldown > 0:
		return

	is_attacking = true
	play_animation("Attack")
	sprite.flip_h = last_direction_x < 0
	attack_cooldown = ATTACK_COOLDOWN_TIME

	# Aktifkan hitbox dan hubungkan sinyalnya
	if attack_hitbox:
		attack_hitbox.monitoring = true
		attack_hitbox.connect("area_entered", _on_attack_hit_area_entered)

	if sfx_player and !sfx_player.playing:
		sfx_player.play()

# === Fungsi untuk menangani tabrakan hitbox ===
func _on_attack_hit_area_entered(area: Area2D) -> void:
	# Pastikan target memiliki method take_damage dan bukan bagian dari player.
	if area.has_method("take_damage") and area.get_parent() != self:
		emit_signal("attack_hit", area.get_parent(), ATTACK_DAMAGE)
		area.get_parent().take_damage(ATTACK_DAMAGE)

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

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range:
		print("Player took damage")
