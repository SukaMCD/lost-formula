extends CharacterBody2D

@export var speed: float = 200

func _physics_process(delta):
	# Gerakan kiri/kanan
	var direction_x = Input.get_axis("left", "right")
	# Gerakan atas/bawah
	var direction_y = Input.get_axis("up", "down")

	# Update velocity berdasarkan input
	velocity.x = direction_x * speed
	velocity.y = direction_y * speed

	move_and_slide()  # Pindahkan karakter dengan physics engine
