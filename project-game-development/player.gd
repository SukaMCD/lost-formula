extends CharacterBody2D

@export var speed: float = 200.0  # Kecepatan karakter
@export var jump_force: float = -300.0  # Kekuatan lompat
@export var gravity: float = 600.0  # Gravitasi

func _physics_process(delta):
	# Tambahkan gravitasi
	if not is_on_floor():
		velocity.y += gravity * delta

	# Gerakan kiri/kanan
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)  # Berhenti perlahan

	# Lompat
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	move_and_slide()  # Fungsi untuk menggerakkan karakter
