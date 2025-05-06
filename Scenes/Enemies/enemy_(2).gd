extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null

@onready var sprite = $AnimatedSprite2D  # Ambil node AnimatedSprite2D

func _physics_process(delta):
	if player_chase and player != null:
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * speed * delta
		
		# Pilih animasi berdasarkan arah
		_play_animation(direction)
	else:
		sprite.play("Idle")  # Animasi idle kalau gak ngejar player

func _play_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		# Gerak horizontal (kiri / kanan)
		sprite.play("Walk")
		
		# Balik arah sprite kalau ke kiri
		if direction.x > 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	elif direction.y < 0:
		# Gerak ke bawah
		sprite.play("Down")
	else:
		# Gerak ke atas
		sprite.play("Up")

func _on_decative_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	print("Player detected:", player.name)

func _on_decative_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	print("Player lost!")
