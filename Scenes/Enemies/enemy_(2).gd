extends CharacterBody2D

@export var speed = 50
@export var max_health = 100
@export var attack_range = 30
@export var attack_damage = 10
@export var attack_cooldown = 1.5

var current_health = max_health
var player_chase = false
var player = null
var can_attack = true

@onready var sprite = $AnimatedSprite2D  # Ambil node AnimatedSprite2D

func _physics_process(delta):
	if player_chase and player != null:
		var direction = (player.global_position - global_position).normalized()
		var distance = global_position.distance_to(player.global_position)

		if distance <= attack_range:
			attack_player()
			sprite.play("Attack")  # Ganti ke animasi serang kalau kamu punya
		else:
			global_position += direction * speed * delta
			_play_animation(direction)
	else:
		sprite.play("Idle")  # Animasi idle kalau gak ngejar player

func attack_player():
	if can_attack and player != null and player.has_method("take_damage"):
		player.take_damage(attack_damage)
		can_attack = false
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true

func take_damage(amount):
	current_health -= amount
	print("Enemy HP:", current_health)
	if current_health <= 0:
		queue_free()  # Enemy mati

func _play_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		sprite.play("Walk")
		sprite.flip_h = direction.x > 0
	elif direction.y < 0:
		sprite.play("Down")
	else:
		sprite.play("Up")

func _on_decative_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	print("Player detected:", player.name)

func _on_decative_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	print("Player lost!")
