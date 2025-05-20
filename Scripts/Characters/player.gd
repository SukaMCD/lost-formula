extends CharacterBody2D
class_name Player

signal hero_mati

# === Movement ===
@export var speed: float = 150
@export var dodge_speed: float = 400  # Kecepatan dodge
@export var dodge_duration: float = 0.2  # Durasi dodge dalam detik

# === Health & Combat ===
@export var max_health: int = 100
@export var current_health: int = 100
@export var invincible_duration: float = 0.5  # Durasi tidak bisa kena damage setelah hit
var invincible_timer: float = 0.0
var is_invincible: bool = false

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var player_alive = true

# === Node References ===
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_player: AudioStreamPlayer2D = $sfx_player
@onready var attack_hitbox: Area2D = $attack_hitbox
@onready var attack_collision: CollisionShape2D = $attack_hitbox/CollisionShape2D
@onready var healthbar = $Healthbar

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
const ATTACK_DAMAGE: int = 20 # Naikkan damage dari 20 ke 30

# === Dodge State ===
var is_dodging: bool = false
var dodge_timer: float = 0.0
var dodge_cooldown: float = 0.0
const DODGE_COOLDOWN_TIME: float = 0.5
var dodge_direction: Vector2 = Vector2.ZERO

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

	# Initialize health and healthbar
	current_health = max_health
	if healthbar:
		healthbar.init_health(max_health)
		print("Player health initialized:", current_health, "/", max_health)

	sprite.animation_finished.connect(_on_animation_finished)

	# Setup attack input if missing
	if not InputMap.has_action("attack"):
		var event := InputEventKey.new()
		event.keycode = KEY_J
		InputMap.add_action("attack")
		InputMap.action_add_event("attack", event)
		
	# Setup dodge input
	if not InputMap.has_action("dodge"):
		var event := InputEventKey.new()
		event.keycode = KEY_K
		InputMap.add_action("dodge")
		InputMap.action_add_event("dodge", event)

	# Disable attack hitbox at start
	if attack_collision:
		attack_collision.disabled = true

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dialog"):
		DialogueManager.show_example_dialogue_balloon(load("res://addons/arahan.dialogue"))
		return
		
# === PHYSICS LOOP ===
func _physics_process(delta: float) -> void:
	if invincible_timer > 0:
		invincible_timer -= delta
		if invincible_timer <= 0:
			is_invincible = false
	
	enemy_attack()
	if !input_enabled or get_tree().paused:
		handle_disabled_state()
		return

	if attack_cooldown > 0:
		attack_cooldown -= delta
	if dodge_cooldown > 0:
		dodge_cooldown -= delta

	# Update dodge timer
	if is_dodging:
		dodge_timer -= delta
		if dodge_timer <= 0:
			end_dodge()
		else:
			velocity = dodge_direction * dodge_speed
			move_and_slide()
			return

	var input_vector := get_input_vector()
	
	# Check for dodge input
	if Input.is_action_just_pressed("dodge") and !is_dodging and dodge_cooldown <= 0:
		start_dodge(input_vector)
		return

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
	if is_dodging:
		return
		
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
		if sfx_player and sfx_player.playing:
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
		if attack_collision:
			attack_collision.disabled = true
		var input_vector := get_input_vector()
		if input_vector.length() > 0:
			handle_moving_animations(input_vector)
		else:
			play_animation("Idle")
			sprite.flip_h = last_direction_x < 0
	elif current_animation == "Dodge":
		end_dodge()
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

	# Enable attack hitbox
	if attack_collision:
		attack_collision.disabled = false
		# Flip hitbox based on direction
		var hitbox_pos = attack_collision.position
		hitbox_pos.x = abs(hitbox_pos.x) * (-1 if sprite.flip_h else 1)
		attack_collision.position = hitbox_pos

	attack_cooldown = ATTACK_COOLDOWN_TIME

	if sfx_player and !sfx_player.playing:
		sfx_player.play()

	# Wait for animation
	await sprite.animation_finished
	
	# Disable attack hitbox
	if attack_collision:
		attack_collision.disabled = true

func _on_attack_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(ATTACK_DAMAGE, global_position)
		print("Hit enemy! Dealing %d damage" % ATTACK_DAMAGE)

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
	if is_invincible or !player_alive:
		print("Player can't take damage - Invincible:", is_invincible, " Alive:", player_alive)
		return
		
	print("Player taking damage:", amount, " Current health before:", current_health)
	current_health -= amount
	print("Player health after damage:", current_health)
	
	is_invincible = true
	invincible_timer = invincible_duration
	
	get_parent().emit_signal("hero_mati")
	
	# Update healthbar
	if healthbar:
		print("Updating healthbar to:", current_health)
		healthbar.health = current_health
	else:
		print("Warning: Healthbar not found!")
	
	# Flash effect
	sprite.modulate = Color(1, 0.3, 0.3, 0.7)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1, 1)
	
	if current_health <= 0:
		die()
	else:
		# Optional: Play hurt animation/sound
		pass

func die() -> void:
	player_alive = false
	# Disable input
	input_enabled = false
	# Play death animation
	play_animation("Death")  # Pastikan ada animasi Death
	# Optional: Play death sound
	print("Player died!")
	# Bisa tambahkan logika game over di sini

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
	if healthbar:
		healthbar.health = current_health

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown and player_alive:
		print("Enemy attacking player!")
		take_damage(10)  # Enemy deals 10 damage
		print("Player health after damage:", current_health)
		enemy_attack_cooldown = false
		await get_tree().create_timer(1.0).timeout
		enemy_attack_cooldown = true

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
		print("Enemy entered attack range")
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		print("Enemy left attack range")
		enemy_inattack_range = false

func start_dodge(direction: Vector2) -> void:
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT * last_direction_x
	
	is_dodging = true
	dodge_timer = dodge_duration
	dodge_direction = direction.normalized()
	dodge_cooldown = DODGE_COOLDOWN_TIME
	play_animation("Dodge")

func end_dodge() -> void:
	is_dodging = false
	dodge_timer = 0.0
	velocity = Vector2.ZERO
