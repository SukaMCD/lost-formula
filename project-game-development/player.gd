extends CharacterBody2D

@export var speed: float = 200

@onready var sprite = $AnimatedSprite2D  # Akses animasi sprite

func _physics_process(_delta):
	# Input arah
	var direction_x = Input.get_axis("left", "right")
	var direction_y = Input.get_axis("up", "down")

	# Bikin vector arah
	var direction = Vector2(direction_x, direction_y).normalized()

	# Update velocity
	velocity = direction * speed

	# Gerakin player
	move_and_slide()

	# Animasi jalan
	if direction.length() > 0:
		if direction_x != 0:
			sprite.flip_h = direction_x < 0  # True kalau ke kiri
			sprite.play("Run")
		elif direction_y != 0:
			sprite.play("Run")  # Bisa ganti animasi sesuai arah vertikal
	else:
		sprite.play("Idle")
