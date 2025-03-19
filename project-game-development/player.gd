extends CharacterBody2D

@export var speed: float = 200

@onready var sprite = $AnimatedSprite2D  # Ini buat akses sprite animasi lo

func _physics_process(delta):
	# Gerakan kiri/kanan
	var direction_x = Input.get_axis("left", "right")
	# Gerakan atas/bawah
	var direction_y = Input.get_axis("up", "down")

	# Update velocity berdasarkan input
	velocity.x = direction_x * speed
	velocity.y = direction_y * speed

	# Pindahkan karakter dengan physics engine
	move_and_slide()

	# Cek apakah karakter lagi jalan atau diem
	if direction_x != 0 or direction_y != 0:
		# Kalau jalan ke kanan
		if direction_x > 0:
			sprite.flip_h = false
			sprite.play("Run")
		# Kalau jalan ke kiri
		elif direction_x < 0:
			sprite.flip_h = true
			sprite.play("Run")
		# Kalau jalan ke atas / bawah (optional, kalau ada animasi lain)
		elif direction_y != 0:
			sprite.play("Run")  # Atau ganti jadi "Run-Up" / "Run-Down" kalau ada
	else:
		sprite.play("Idle")  # Kalau diem, balik ke idle
