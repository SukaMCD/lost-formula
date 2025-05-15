extends CharacterBody2D
class_name Player

# === Movement ===
@export var speed: float = 150

# === Health / Combat flags (tetap ada jika nanti mau pakai) ===
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

# === Node References ===
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_player: AudioStreamPlayer2D = $sfx_player
@onready var attack_hitbox: Area2D = $AttackHitbox

# === Input & State ===
var input_enabled: bool = true
var is_attacking: bool = false
var current_animation: String = "Idle"
var last_direction_x: int = 1    # 1 = kanan, -1 = kiri
var last_direction_y: int = 1    # 1 = depan, -1 = belakang
var last_move_anim: String = "Idle"  # Simpan animasi terakhir gerak

# === Timers ===
var footstep_timer: float = 0.0
const FOOTSTEP_DELAY: float = 0.3

var attack_cooldown: float = 0.0
const ATTACK_COOLDOWN_TIME: float = 0.5
const ATTACK_DAMAGE: int = 20

# === Inventory / Tracking ===
var collected_items: Dictionary = {}

# === Sinyal ===
signal attack_hit(target, damage)

# === READY ===
func _ready():
	add_to_group("player")
	process_mode = Node.PROCESS_MODE_PAUSABLE

	if sfx_player:
		sfx_player.volume_db = 5

	sprite.animation_finished.connect(_on_animation_finished)

	# Setup attack input jika belum ada
	if not InputMap.has_action("attack"):
		var ev := InputEventKey.new()
		ev.keycode = KEY_K
		InputMap.add_action("attack")
		InputMap.action_add_event("attack", ev)

	if not attack_hitbox:
		printerr("Error: AttackHitbox node not found!")

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dialog"):
		DialogueManager.show_example_dialogue_balloon(load("res://addons/arahan.dialogue"))
		return

func _physics_process(delta: float) -> void:
	enemy_attack()
	if not input_enabled or get_tree().paused:
		handle_disabled_state()
		return

	if attack_cooldown > 0:
		attack_cooldown -= delta

	var iv := get_input_vector()
	process_movement(iv)
	update_animation(iv)
	move_and_slide()

func get_input_vector() -> Vector2:
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()

func process_movement(iv: Vector2) -> void:
	velocity = iv * speed
	if iv.x != 0:
		last_direction_x = sign(iv.x)
	if iv.y != 0:
		last_direction_y = sign(iv.y)

func update_animation(iv: Vector2) -> void:
	if is_attacking:
		return

	if Input.is_action_just_pressed("attack") and attack_cooldown <= 0:
		start_attack()
		return

	if iv.length() > 0:
		handle_moving_animations(iv)
	else:
		# Idle berdasarkan arah terakhir
		play_last_direction_idle()
		if sfx_player and sfx_player.is_playing():
			sfx_player.stop()

func handle_moving_animations(iv: Vector2) -> void:
	if iv.x != 0:
		play_animation("Walk")
		sprite.flip_h = iv.x < 0
		last_move_anim = "Walk"
	elif iv.y < 0:
		play_animation("Up")
		sprite.flip_h = last_direction_x < 0
		last_move_anim = "Up"
	elif iv.y > 0:
		play_animation("Down")
		sprite.flip_h = last_direction_x < 0
		last_move_anim = "Down"

	play_footstep_sound()

func play_last_direction_idle() -> void:
	# Gunakan animasi gerak terakhir sebagai idle
	# misal: "Walk", "Up", "Down", atau default "Idle"
	var anim = last_move_anim
	play_animation(anim)
	# set frame ke frame terakhir
	var frame_count = sprite.frames.get_frame_count(anim)
	if frame_count > 0:
		sprite.frame = frame_count - 1
	sprite.playing = false
	# set flip sesuai arah terakhir
	if anim == "Walk":
		sprite.flip_h = last_direction_x < 0
	else:
		sprite.flip_h = last_direction_x < 0

func play_animation(anim_name: String) -> void:
	if current_animation != anim_name:
		current_animation = anim_name
		sprite.play(anim_name)
		sprite.playing = true

func _on_animation_finished() -> void:
	if current_animation == "Attack":
		is_attacking = false
		if attack_hitbox:
			attack_hitbox.monitoring = false
			attack_hitbox.disconnect("area_entered", Callable(self, "_on_attack_hit_area_entered"))
		var iv = get_input_vector()
		if iv.length() > 0:
			handle_moving_animations(iv)
		else:
			play_last_direction_idle()

func start_attack():
	if is_attacking or attack_cooldown > 0:
		return
	is_attacking = true
	play_animation("Attack")
	sprite.flip_h = last_direction_x < 0
	attack_cooldown = ATTACK_COOLDOWN_TIME
	if attack_hitbox:
		attack_hitbox.monitoring = true
		attack_hitbox.connect("area_entered", Callable(self, "_on_attack_hit_area_entered"))
	if sfx_player and not sfx_player.playing:
		sfx_player.play()

func _on_attack_hit_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage") and area.get_parent() != self:
		emit_signal("attack_hit", area.get_parent(), ATTACK_DAMAGE)
		area.get_parent().take_damage(ATTACK_DAMAGE)

func play_footstep_sound() -> void:
	if footstep_timer > 0:
		footstep_timer -= get_process_delta_time()
	else:
		if sfx_player and not sfx_player.playing:
			sfx_player.play()
			footstep_timer = FOOTSTEP_DELAY

func handle_disabled_state() -> void:
	velocity = Vector2.ZERO
	play_last_direction_idle()
	if sfx_player and sfx_player.playing:
		sfx_player.stop()

func track_item(item_id: String, quantity: int) -> void:
	collected_items[item_id] = collected_items.get(item_id, 0) + quantity
	print("Item terkumpul:", collected_items)

func set_input_enabled(enabled: bool) -> void:
	input_enabled = enabled
	if not enabled:
		velocity = Vector2.ZERO
		sprite.stop()
		if sfx_player and sfx_player.playing:
			sfx_player.stop()

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range:
		print("Player took damage")

func player():
	pass
