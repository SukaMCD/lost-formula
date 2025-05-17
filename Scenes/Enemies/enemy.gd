extends CharacterBody2D

@export_group("Movement")
@export var speed = 150
@export var acceleration = 900
@export var friction = 800

@export_group("Combat")
@export var attack_damage = 10
@export var attack_distance = 50
@export var min_distance = 20
@export var detection_radius = 200

@export_group("Health")
@export var max_health: int = 50
@export var current_health: int = 50

var player = null
var can_attack = true
var is_alive = true

@onready var sprite = $AnimatedSprite2D
@onready var detection_area = $DetectionArea

func _ready():
	if detection_area:
		var shape = detection_area.get_node("CollisionShape2D")
		if shape and shape.shape:
			shape.shape.radius = detection_radius

func take_damage(amount: int) -> void:
	if !is_alive:
		return
		
	current_health -= amount
	print("Enemy took %d damage! Health: %d/%d" % [amount, current_health, max_health])
	
	# Flash effect
	sprite.modulate = Color(1, 0.3, 0.3, 0.7)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1, 1)
	
	if current_health <= 0:
		die()
	else:
		# Optional: Play hurt animation
		pass

func die() -> void:
	is_alive = false
	print("Enemy died!")
	# Play death animation if available
	sprite.play("Death")  # Menggunakan sprite.play() instead of play_animation()
	# Disable collision
	collision_layer = 0
	collision_mask = 0
	# Wait for animation
	await sprite.animation_finished
	# Remove enemy
	queue_free()

func _physics_process(delta):
	if !is_alive:
		return
		
	if !player:
		apply_friction(delta)
		sprite.play("Idle")
		return
		
	var direction = global_position.direction_to(player.global_position)
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= attack_distance and can_attack:
		# Stop and attack
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		attack()
	else:
		# Chase player but maintain minimum distance
		var target_velocity
		if distance < min_distance:
			# Bergerak menjauh dari player
			target_velocity = -direction * speed
		elif distance > attack_distance:
			# Mengejar player
			target_velocity = direction * speed
		else:
			# Di antara min_distance dan attack_distance, diam di tempat
			target_velocity = Vector2.ZERO
			
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
		
	move_and_slide()
	update_animation()

func attack():
	if !can_attack or !is_alive:
		return
		
	sprite.play("Attack")
	if player.has_method("take_damage"):
		player.take_damage(attack_damage)
	
	can_attack = false
	await get_tree().create_timer(1.0).timeout
	can_attack = true

func apply_friction(delta):
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()

func update_animation():
	if velocity.length() > 10:
		sprite.play("Run")
		sprite.flip_h = velocity.x > 0
	elif !can_attack:
		sprite.play("Attack")
	else:
		sprite.play("Idle")

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_detection_area_body_exited(body):
	if body == player:
		player = null
